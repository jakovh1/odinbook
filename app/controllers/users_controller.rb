class UsersController < ApplicationController
  def index
    pending_users = Follow.outgoing_follow_requests_for(current_user).map(&:followee)
    non_following_users = User.non_following_for(current_user)
    @users = pending_users + non_following_users
  end
  def show
    @user = User.includes(:posts).find_by!(username: params[:username])
    @chat = Chat.between(current_user, @user)
  end

  def update_avatar
    if current_user.update_avatar(params[:image])
      flash[:alert] = "Avatar updated successfully."
      redirect_to profile_path(current_user.username)
    else
      flash.now[:alert] = "Uploaded file is not an image."
      ::TurboReplacer.call(controller_instance: self, dom_target: "toast", partial: "layouts/toast")
    end
  end
end
