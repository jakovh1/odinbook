class NotificationCreator
  def self.call(submitter:, recipient:, notifiable:)
    begin

      if submitter.id != recipient.id
        notification = Notification.create!(submitter: submitter, recipient: recipient, notifiable: notifiable)

        Turbo::StreamsChannel.broadcast_update_later_to(
                                                          recipient,
                                                          target: "notification-counter",
                                                          html: recipient.notifications.unread.count
                                                       )

        notification
      end


    rescue StandardError => e
      Rails.logger.error("Notification creation failed: #{e.class} - #{e.message}")
    rescue PG::Error => e
      Rails.logger.error("PostgreSQL error during notification creation: #{e.class} - #{e.message}")
    end
  end
end
