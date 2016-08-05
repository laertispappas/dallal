require 'dallal/notifications/base_notification'
module Dallal
  module Notifications
    class EmailNotification < BaseNotification
      attr_reader :from_name, :from_email
      attr_reader :template_name

      def initialize(notification, target)
        super(notification, target)

        @from_name = Dallal.configuration.from_name
        @from_email = Dallal.configuration.from_email
      end

      def notifier
        Dallal::Notifiers::EmailNotifier.new(self)
      end

      def template template
        @template_name = template
      end
    end
  end
end
