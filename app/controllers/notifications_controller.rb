class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications
  end

  def update
  end
end
