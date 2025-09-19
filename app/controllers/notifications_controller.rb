class NotificationsController < ApplicationController
  def index
    current_user.notifications.unread.update_all(is_read: true)
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def update
  end
end
