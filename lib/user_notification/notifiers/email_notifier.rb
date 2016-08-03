module UserNotification
  module Notifiers
    class EmailNotifier < Notifier

      def notify(notification)
      end

      def mailer
        UserNotification::Mailer
      end

      def deliver
      end

      def deliver!
      end
    end
  end
end
