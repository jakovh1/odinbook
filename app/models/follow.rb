class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  scope :incoming_follow_requests_for, ->(user) { includes(:follower).where(followee: user, status: "pending") }
  scope :outgoing_follow_requests_for, ->(user) { where(follower: user, status: "pending") }

  has_one :notification, as: :notifiable, dependent: :destroy

  def accept!
    return false unless status == "pending"

    update!(status: "accepted")
  end
end
