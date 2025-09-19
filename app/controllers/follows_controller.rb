class FollowsController < ApplicationController
  before_action :set_follow, only: %i[ update destroy ]

  # GET /follows or /follows.json
  def index
    @follows = Follow.all
  end

  # POST /follows or /follows.json
  def create
    followee = User.find_by(id: params[:followee_id])

    # Execute if the user with the given id does not exist and inform the user.
    unless followee
      return render_turbo_stream_toast("Given user does not exist.")
    end

    # Execute if the user exists and following with the given user does not exist.
    unless Follow.find_by(follower: current_user, followee: followee)
      create_following(followee)
      return
    end

    # Execute if following already exists.
    render_turbo_stream_toast("You are already following the #{followee.username} or already sent follow request to them.")
  end

  # PATCH/PUT /follows/1 or /follows/1.json
  def update
    if @follow.valid? && @follow.status == "pending"

      if @follow.update(status: "accepted")
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.update("follow_#{@follow.follower.id}", partial: "posts/incoming_request_state", locals: { request_state: "Accepted" })
          end
        end
      else
        render_error_message
      end
    end
  end

  # DELETE /follows/1 or /follows/1.json
  def destroy
    # Executes if follow with the given id does not exist.
    unless @follow
      return render_turbo_stream_toast("You are not following given user.")
    end

    # Deletes the follow if it exists
    delete_following
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_follow
    @follow = following_exists?
  end

  # Checks if following exists for destroy action.
  def following_exists?
    Follow.find_by(follower: current_user, id: params[:id]) ||
      Follow.find_by(followee: current_user, id: params[:id])
  end

  def render_turbo_stream_toast(flash_message)
    flash.now[:alert] = flash_message
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("toast", partial: "layouts/toast")
      end
    end
  end

  def create_following(followee)
    follow = current_user.users_following.build(followee: followee, status: "pending")
    respond_to do |format|
      format.turbo_stream do
        if follow.save
          render turbo_stream: turbo_stream.update("follow-container-#{followee.id}", partial: "users/follow_button", locals: { user: followee })
          ::NotificationCreator.call(submitter: current_user, recipient: followee, notifiable: follow)
        else
          render_error_message
        end
      end
    end
  end

  def delete_following
    respond_to do |format|
      format.turbo_stream do
        if @follow.destroy
          if @follow.follower == current_user
            render turbo_stream: turbo_stream.update("follow-container-#{@follow.followee_id}", partial: "users/follow_button", locals: { user: @follow.followee })
          else
            render turbo_stream: turbo_stream.update("follow_#{@follow.follower.id}", partial: "posts/incoming_request_state", locals: { request_state: "Declined" })
          end
        else
          render_error_message
        end
      end
    end
  end

  def render_error_message
    flash.now[:alert] = "An error occurred, please try again."
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("toast", partial: "layouts/toast")
      end
    end
  end
end
