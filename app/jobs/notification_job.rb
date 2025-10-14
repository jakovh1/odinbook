class NotificationJob < ApplicationJob
  queue_as :default

  def perform(submitter_id:, recipient_id:, notifiable:)
    submitter = User.find(submitter_id)
    recipient = User.find(recipient_id)
    ::NotificationCreator.call(submitter: submitter, recipient: recipient, notifiable: notifiable)
  end
end
