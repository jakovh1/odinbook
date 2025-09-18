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
    like = Like.new(post: @post, user: current_user)

    if like.save

      ::NotificationCreator.call(submitter: current_user, recipient: @post.author, notifiable: like)

      respond_to do |format|
        format.turbo_stream { render "posts/like", locals: { post: @post } }
      end
    else
      flash.now[:alert] = "An error occurred, please try again."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("toast", partial: "layouts/toast")
        end
      end
    end
  end

  def dislike
    @post = Post.find(params[:id])
    if @post&.likers.delete(current_user)
      respond_to do |format|
        format.turbo_stream { render "posts/like", locals: { post: @post } }
      end
    else
      flash.now[:alert] = "An error occurred, please try again."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("toast", partial: "layouts/toast")
        end
      end
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
    if post_params[:content].present?
      if is_url?(post_params[:content]) && FastImage.type(post_params[:content])
        photo_post = PhotoPost.create!(image_url: post_params[:content])
        @post = Post.new(postable: photo_post, author: current_user)
      else
        text_post = TextPost.create!(post_params)
        @post = Post.new(postable: text_post, author: current_user)
      end
    elsif post_params[:image].present?
      puts post_params[:image]
      puts FastImage.type(post_params[:image])
      photo_post = PhotoPost.create!(post_params)
      @post = Post.new(postable: photo_post, author: current_user)
    end


    respond_to do |format|
      if @post&.save
        format.html { redirect_to user_post_path(current_user.id, @post.id), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        @post = Post.new
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @post.errors, status: :unprocessable_content }
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
      return params.require(:post).permit(:content) if params[:post]&.[](:content).present?

      return params.require(:post).permit(:image) if params[:post]&.[](:image).present?

      params
    end

    def is_url?(submitted_content)
      begin
        uri = URI.parse(submitted_content)
        uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      rescue URI::InvalidURIError
        false
      end
    end
end
