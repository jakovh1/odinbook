class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true, length: { minimum: 1, maximum: 40000 }

  has_many :notifications, as: :notifiable, dependent: :destroy
end
