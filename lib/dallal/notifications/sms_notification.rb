require 'dallal/notifications/base_notification'
module Dallal
  module Notifications
    class SmsNotification < BaseNotification
      attr_reader :sms_payload
 
      def payload payload
        @sms_payload = payload
      end

      def notifier
        Dallal::Notifiers::SmsNotifier.new(self)
      end
    end
  end
end
