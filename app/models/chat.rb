class Chat < ApplicationRecord
  has_many :chat_participations, dependent: :destroy
  has_many :participants, through: :chat_participations

  has_many :messages, dependent: :destroy

  def to_param
    uuid
  end

  def mark_as_read(user_id)
    messages.where.not(author_id: user_id).where(is_read: false).update_all(is_read: true)
  end

  def ordered_messages
    messages
      .where.not(content: nil)
      .order(created_at: :asc)
  end

  def self.between(sender, recipient)
    self.joins(:chat_participations)
        .where(chat_participations: { participant_id: [ sender.id, recipient.id ] })
        .group("chats.id")
        .having("COUNT(chat_participations.id) = 2")
        .first
  end

  def find_other_recipient(user_id)
    others = chat_participations.where.not(participant_id: user_id)
    return others.first.participant if others.count == 1

    nil
  end

  def self.create_chat!(recipient, current_user)
    unless self.between(current_user, recipient)
      ActiveRecord::Base.transaction do
        chat = self.create!
        chat.chat_participations.create!(participant: recipient)
        chat.chat_participations.create!(participant: current_user)
        return chat
      end
    end

    nil
  end
end
