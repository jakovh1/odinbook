class MessagesController < ApplicationController
  # POST /messages or /messages.json
  def create
    chat = current_user.chats.find_by!(uuid: params[:chat_uuid])
    return render_error_toast if params[:message][:content].strip.blank?

    message = chat.messages.create!(content: params[:message][:content], author: current_user)
    ChatChannel.broadcast_to(chat, message)

    update_ui_for(current_user, "last-message-chat-#{chat.id}", message.content)

    if recipient = chat.find_other_recipient(current_user.id)
      update_recipient_ui(recipient, chat.id, message.content)
    end
  end

  private

  def update_ui_for(participant, target, content)
    Turbo::StreamsChannel.broadcast_update_later_to(
                                                      participant,
                                                      target: target,
                                                      html: content
                                                    )
  end

  def update_recipient_ui(recipient, chat_id, message)
    update_ui_for(recipient, "message-counter", recipient.unread_messages_count)
    update_ui_for(recipient, "message-counter-per-chat-#{chat_id}", recipient.unread_messages_count_per_chat(chat_id))
    update_ui_for(recipient, "last-message-chat-#{chat_id}", message)
  end
end
