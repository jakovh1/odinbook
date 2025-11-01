class ChatChannel < ApplicationCable::Channel
  rescue_from ActiveRecord::RecordNotFound, with: :reject_subscription

  def subscribed
    # stream_from "some_channel"
    @chat = Chat.find_by!(uuid: params[:chat_uuid])
    reject unless @chat.participants.exists?(current_user.id)

    stream_for @chat
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def receive(data)
  end

  private

  def reject_subscription
    reject
  end
end
