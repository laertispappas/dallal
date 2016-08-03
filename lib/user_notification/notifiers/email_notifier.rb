module UserNotification
  module Notifiers
    class EmailNotifier < Notifier

      def notify!
      end

      def persist!
      end

      private
      def mailer
        UserNotification::Mailer
      end
    end
  end
end
