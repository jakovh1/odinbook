class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  validates :author, presence: true

  has_many :comments, foreign_key: "post_id", dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  belongs_to :postable, polymorphic: true

  scope :newsfeed_for, ->(user) {
    followees_ids = user.followees.where(follows: { status: "accepted" }).select(:id)
    includes(:author).where(author: followees_ids).or(where(author: user.id)).order(created_at: :desc)
  }

  def to_param
    uuid
  end
end
