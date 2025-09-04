class Post < ApplicationRecord
  belongs_to :author, class_name: "User"

  has_and_belongs_to_many :likers, class_name: "User"

  validates :content, presence: true, length: { minimum: 3, maximum: 40000 }
end
