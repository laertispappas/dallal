module UserNotification
  module Notifiers
    class EmailNotifier < Notifier
      def notify!
        # TODO please pass a email notification instead
        define_email_methods
        mailer.notify(notification).deliver_now
      end

      def persist!
      end

      private

      def define_email_methods
        [:from_email, :from_name].each do |name|
          notification.define_singleton_method(name) do
            UserNotification.configuration.send(name)
          end
        end
      end

      def mailer
        UserNotification::Mailer
      end
    end
  end
end
