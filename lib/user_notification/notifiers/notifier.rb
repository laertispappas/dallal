require 'user_notification/abstract_interface'

module UserNotification
  module Notifiers
    class Notifier
      attr_reader :notification

      include AbstractInterface
      def initialize(notification)
        @notification = notification
      end

      def self.email(notification)
        UserNotification::Notifiers::EmailNotifier.new(notification)
      end
  
      def self.sms(notification)
        UserNotification::Notifiers::SmsNotifier.new(notification)
      end

      def notify(*args)
        Notifier.api_not_implemented(self)
      end
    end
  end
end

require 'user_notification/notifiers/email_notifier'
require 'user_notification/notifiers/sms_notifier'
