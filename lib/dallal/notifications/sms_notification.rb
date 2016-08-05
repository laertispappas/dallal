require 'dallal/notifications/base_notification'
module Dallal
  module Notifications
    class SmsNotification < BaseNotification
      attr_reader :to
      attr_reader :from
      attr_reader :body

      def initialize(notification, target)
        super(notification, target)
        @from = Dallal.configuration.sms_from
      end
 
      def template template
        raise NotImplementedError
      end

      def message message
        @body = message
      end

      def recipient recipient_number
        @to = recipient_number
      end

      def to
        @to || target.phone_number
      end

      def notifier
        Dallal::Notifiers::SmsNotifier.new(self)
      end
    end
  end
end
