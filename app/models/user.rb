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
  has_many :posts, foreign_key: "author_id"
  has_many :comments, foreign_key: "user_id"

  # Followers - Followee associations
  has_many :users_following, foreign_key: "follower_id", class_name: "Follow"
  has_many :followees, through: :users_following, source: :followee

  has_many :users_followers, foreign_key: "followee_id", class_name: "Follow"
  has_many :followers, through: :users_followers, source: :follower

  # Like (User-Post) association
  has_many :liked_posts, through: :likes, source: :post

  has_one_attached :image

  # Notification association
  has_many :notifications, foreign_key: "recipient_id"
end
