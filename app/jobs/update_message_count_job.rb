class UpdateMessageCountJob < ApplicationJob
  queue_as :default

  def perform(user_id:, chat_id:)
    user = User.find(user_id)

    unread_messages_count = user.unread_messages_count
    unread_messages_count_per_chat = user.unread_messages_count_per_chat(chat_id)

    ::MessageCountBroadcaster.call(
                                    user: user,
                                    chat_id: chat_id,
                                    unread_messages_count: unread_messages_count,
                                    unread_messages_count_per_chat: unread_messages_count_per_chat
                                  )
  end
end
