class PostsController < ApplicationController
  # GET /posts or /posts.json
  def index
    @posts = Post.newsfeed_for(current_user)
    @post = current_user.posts.build
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.includes(:author).find_by!(uuid: params[:uuid])
    @comment = Comment.new(user: current_user, post: @post)
  end

  def like
    post = Post.find_by!(uuid: params[:uuid])
    like = post.likes.create!(user: current_user)

    NotificationJob.perform_later(submitter_id: current_user.id, recipient_id: post.author_id, notifiable: like)
    head :ok
  end

  def dislike
    post = Post.find_by!(uuid: params[:uuid])
    like = Like.find_by!(post: post, user: current_user)

    if like.destroy
      head :ok
    else
      render_error_toast
    end
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # POST /posts or /posts.json
  def create
    post = current_user.create_post(post_param)

    if post&.persisted?
      PostBroadcastJob.perform_later(post.id)
      redirect_to user_post_path(current_user.username, post.uuid), alert: "Post was successfully created."
    else
      flash.now[:alert] = "Either enter a text or attach a photo."
      ::TurboReplacer.call(controller_instance: self, dom_target: "toast", partial: "layouts/toast")
    end
  end

  private

  def post_param
    if params[:post]&.[](:content).present?
      params.require(:post).permit(:content)[:content]
    elsif params[:post]&.[](:image).present?
      params.require(:post).permit(:image)[:image]
    end
  end
end
