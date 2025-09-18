class NotificationCreator
  def self.call(submitter:, recipient:, notifiable:)
    if submitter.id != recipient.id
      notification = Notification.create!(submitter: submitter, recipient: recipient, notifiable: notifiable)
    end

    notification
  end
end
