class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :comments, foreign_key: "post_id", dependent: :destroy

  has_many :likes
  has_many :likers, through: :likes, source: :user

  belongs_to :postable, polymorphic: true
end
