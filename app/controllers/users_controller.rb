class UsersController < ApplicationController
  def index
    pending_users = Follow.outgoing_follow_requests(current_user).map(&:followee)
    non_following_users = User.where.not(id: current_user.followees.pluck(:id) + [ current_user.id ])
    @users = pending_users + non_following_users
  end
  def show
    @user = User.includes(:posts).find_by(username: params[:username])
    @chat = Chat.between(current_user, @user)
  end

  def update_avatar
    if FastImage.type(params[:image]) && params[:id].to_i == current_user.id
      current_user.image.purge_later if current_user.image.attached?

      current_user.image.attach(params[:image])

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("show-view-avatar", partial: "users/user_avatar", locals: { user: current_user })
        end
      end
    else
      flash.now[:alert] = "Uploaded file is not an image."

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("toast", partial: "layouts/toast")
        end
      end
    end
  end
end
