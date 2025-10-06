class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # User data validations
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                      length: { minimum: 3, maximum: 30 },
                      format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }

  validates :email, length: { minimum: 6, maximum: 254 }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "invalid email address format" }
  validates :password, length: { minimum: 8 }, if: :password_required?

  # Posts and Comments associations
  has_many :posts, foreign_key: "author_id", dependent: :destroy
  has_many :comments, foreign_key: "user_id", dependent: :destroy

  # Followers - Followee associations
  has_many :users_following, foreign_key: "follower_id", class_name: "Follow", dependent: :destroy
  has_many :followees, through: :users_following, source: :followee

  has_many :users_followers, foreign_key: "followee_id", class_name: "Follow", dependent: :destroy
  has_many :followers, through: :users_followers, source: :follower

  # Like (User-Post)
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_one_attached :image

  # Notification association
  has_many :notifications, foreign_key: "recipient_id", dependent: :destroy
  has_many :triggered_notifications, class_name: "Notification", foreign_key: "submitter_id", dependent: :destroy

  # Chat associations
  has_many :chat_participations, foreign_key: "participant_id"
  has_many :chats, through: :chat_participations

  has_many :messages, foreign_key: "author_id"

  def unread_messages_count
    Message.where(chat_id: chats.select(:id))
          .where.not(author_id: id)
          .where(is_read: false)
          .count
  end

  def unread_messages_count_per_chat(chat_id)
    Message.where(chat_id: chat_id)
           .where.not(author_id: id)
           .where(is_read: false)
           .count
  end
end
