class Message < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :chat

  scope :unread, -> { where(is_read: false) }
end
