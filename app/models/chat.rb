class Chat < ApplicationRecord
  has_many :chat_participations, dependent: :destroy
  has_many :participants, through: :chat_participations

  has_many :messages, dependent: :destroy

  def mark_as_read(user_id)
    messages.where.not(author_id: user_id).where(is_read: false).update_all(is_read: true)
  end

  def ordered_messages
    messages
      .where.not(content: nil)
      .order(created_at: :asc)
  end

  def self.between(sender, recipient)
    chat = Chat.joins(:chat_participations)
               .where(chat_participations: { participant_id: [ sender.id, recipient.id ] })
               .group("chats.id")
               .having("COUNT(chat_participations.id) = 2")
               .first


    return chat if chat.present?

    nil
  end

  def self.find_recipient(chat, current_user)
    others = chat.chat_participations.where.not(participant_id: current_user.id)
    return others.first.participant if others.count == 1

    nil
  end

  def self.chats_and_recipients(current_user)
    ChatParticipation.includes(:participant, chat: :messages)
                     .where(chat_id: current_user.chat_ids)
                     .where.not(participant_id: current_user.id)
                     .sort_by { |cp| cp.chat.messages.last&.created_at || Time.at(0) }
                     .reverse
  end
end
