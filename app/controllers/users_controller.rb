class UsersController < ApplicationController
  def show
    puts params.inspect
    @user = User.includes(:posts).find_by(username: params[:username])
    puts @user.inspect
    puts @user.posts.inspect
  end
end
