class UsersController < ApplicationController
  def index
    pending_users = Follow.outgoing_follow_requests(current_user).map(&:followee)
    non_following_users = User.where.not(id: current_user.followees.pluck(:id) + [ current_user.id ])
    @users = pending_users + non_following_users
  end
  def show
    puts params.inspect
    @user = User.includes(:posts).find_by(username: params[:username])
    puts @user.inspect
    puts @user.posts.inspect
  end
end
