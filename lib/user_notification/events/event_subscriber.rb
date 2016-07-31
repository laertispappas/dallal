module UserNotification
  module Events
    class EventSubscriber
      include UserNotification::Events::Subscriber

      #TODO Refactor this
      ActiveSupport::Notifications.subscribe('user_notifications') do |_,_,_,_,payload|
        new(payload).execute
      end

      def initialize(payload)
        @payload = payload
      end

      def execute
        if should_create_notifications?
          # Trigger an ActiJob for this notification
          UserNotificationJob.perform_later payload[:class], payload[:id], payload[:event].to_s
        end
      end

      private
      attr_reader :payload

      # TODO This silently ignores creating a notification
      # add a warning here or raise exception if not applicable
      def should_create_notifications?
        # Are notifications enabled? && is class in Notifiables?
        UserNotification.configuration.enabled? && Observer::NOTIFIABLES.include?(payload[:class])
      end
    end
  end
end
