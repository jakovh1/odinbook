class CommentsController < ApplicationController
  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(user: current_user)
  end

  # POST /comments or /comments.json
  def create
    @post = Post.find(uuid: params[:post_id])
    return render_error_toast if params[:comment][:content].strip.blank?

    @comment = @post.comments.create!(content: params[:comment][:content].strip, user: current_user)

    if @comment.persisted?
      flash.now[:alert] = "Your reply has been sent."
      render turbo_stream: [
                              turbo_stream.replace("toast", partial: "layouts/toast"),
                              turbo_stream.prepend("comments", partial: "comments/comment", locals: { comment: @comment }),
                              turbo_stream.replace("comment_post_#{@post.id}", partial: "posts/comment_icon", locals: { post: @post })
                            ]

      NotificationJob.perform_later(submitter_id: current_user.id, recipient_id: @post.author_id, notifiable: @comment)
    else
      render :new
    end
  end
end
