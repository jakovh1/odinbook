class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :comments, foreign_key: "post_id", dependent: :destroy

  has_and_belongs_to_many :likers, class_name: "User", join_table: "posts_likes"

  belongs_to :postable, polymorphic: true, dependent: :destroy
end
