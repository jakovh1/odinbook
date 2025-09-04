class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false },
                      length: { minimum: 3, maximum: 30 },
                      format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }

  validates :email, length: { minimum: 6, maximum: 254 }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "invalid email address format" }
  validates :password, length: { minimum: 8 }, if: :password_required?

  has_many :posts, foreign_key: "author_id"

  has_and_belongs_to_many :liked_posts, class_name: "Post"
end
