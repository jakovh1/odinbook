class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /posts or /posts.json
  def index
    followees_ids = current_user.followees.where(follows: { status: "accepted" }).pluck(:id)
    @posts = Post.where(author: followees_ids + [ current_user.id ])
    @incoming_follow_requests = Follow.incoming_follow_requests(current_user).includes(:follower)
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.includes(:author).find(params[:id])
    @comment = Comment.new(user: current_user, post: @post)
  end

  def like
    @post = Post.find(params[:id])
    if @post.likers << current_user
      respond_to do |format|
        format.turbo_stream { render "posts/like", locals: { post: @post } }
      end
    else

    end
  end

  def dislike
    @post = Post.find(params[:id])
    if @post.likers.delete(current_user)
      respond_to do |format|
        format.turbo_stream { render "posts/like", locals: { post: @post } }
      end
    else

    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(content: post_params[:content], author_id: current_user.id)

    respond_to do |format|
      if @post.save
        format.html { redirect_to user_post_path(current_user.id, @post.id), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :content ])
    end
end
