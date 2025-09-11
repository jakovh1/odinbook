class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  scope :incoming_follow_requests, ->(user) { where(followee: user, status: "pending") }
  scope :outgoing_follow_requests, ->(user) { where(follower: user, status: "pending") }
end
