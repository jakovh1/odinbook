class NotificationCreator
  def self.call(submitter:, recipient:, notifiable:)
    begin

      if submitter.id != recipient.id

        notification = create_notification_for(notifiable: notifiable, submitter: submitter, recipient: recipient)

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

  def self.create_notification_for(notifiable:, submitter:, recipient:)
    if notifiable.respond_to?(:notification)
      notifiable.create_notification!(submitter: submitter, recipient: recipient)
    elsif notifiable.respond_to?(:notifications)
      notifiable.notifications.create!(submitter: submitter, recipient: recipient)
    else
      raise ArgumentError, "Notifiable object does not support notification creation"
    end
  end

  private_class_method :create_notification_for
end
