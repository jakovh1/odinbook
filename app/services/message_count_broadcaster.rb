class MessageCountBroadcaster
  def self.call(user:, chat_id:, unread_messages_count:, unread_messages_count_per_chat:)
    Turbo::StreamsChannel.broadcast_update_to(
                                                user,
                                                target: "message-counter",
                                                html: unread_messages_count > 0 ? unread_messages_count : nil
                                              )
    Turbo::StreamsChannel.broadcast_update_to(
                                                user,
                                                target: "message-counter-per-chat-#{chat_id}",
                                                html: unread_messages_count_per_chat > 0 ? unread_messages_count_per_chat : nil
                                              )
  end
end
