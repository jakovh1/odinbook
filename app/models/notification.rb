class Notification < ApplicationRecord
  belongs_to :submitter, class_name: "User"
  belongs_to :recipient, class_name: "User"

  belongs_to :notifiable, polymorphic: true, dependent: :destroy
end
