class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    @chat = Chat.find(params[:chat_id])
    reject unless @chat && @chat.participants.exists?(current_user.id)

    stream_for @chat
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def receive(data)
  end
end
