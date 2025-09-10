class FollowsController < ApplicationController
  before_action :set_follow, only: %i[ show edit update destroy ]

  # GET /follows or /follows.json
  def index
    @follows = Follow.all
  end

  # GET /follows/1 or /follows/1.json
  def show
  end

  # GET /follows/new
  def new
    @follow = Follow.new
  end

  # GET /follows/1/edit
  def edit
  end

  # POST /follows or /follows.json
  def create
    followee = User.find_by(id: params[:followee_id])

    # Execute if the user with the given id does not exist and inform the user.
    unless followee
      return render_turbo_stream_toast("Given user does not exist.")
    end

    # Execute if the user exists and following with the given user does not exist.
    unless following_exists?(followee)
      create_following(followee)
      return
    end

    # Execute if following already exists.
    render_turbo_stream_toast("You are already following the #{followee.username} or already sent follow request to them.")
  end

  # PATCH/PUT /follows/1 or /follows/1.json
  def update
    respond_to do |format|
      if @follow.update(follow_params)
        format.html { redirect_to @follow, notice: "Follow was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @follow }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1 or /follows/1.json
  def destroy
    @follow.destroy!

    respond_to do |format|
      format.html { redirect_to follows_path, notice: "Follow was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follow
      @follow = Follow.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def follow_params
      params.expect(follow: [ :follower_id, :followee_id, :status ])
    end

    def render_turbo_stream_toast(flash_message)
      flash.now[:alert] = flash_message
      respond_to do |format|
        turbo_stream.replace("toast", partial: "layouts/toast")
      end
    end

    def following_exists?(followee)
      Follow.find_by(follower: current_user, followee: followee)
    end

    def build_follow(followee)
      current_user.users_following.build(followee: followee, status: "pending")
    end

    def create_following(followee)
      respond_to do |format|
        format.turbo_stream do
          if build_follow(followee).save
            render turbo_stream: turbo_stream.replace("follow-container", partial: "users/follow_button", locals: { user: followee })
          else
            render turbo_stream: turbo_stream.replace("follow-container", partial: "users/follow_button", locals: { user: followee, error: "Could not follow" })
          end
        end
      end
    end
end
