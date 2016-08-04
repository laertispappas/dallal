require 'dallal/abstract_interface'

module Dallal
  module Notifiers
    class Notifier
      attr_reader :notification

      include AbstractInterface
      def initialize(notification)
        @notification = notification
      end

      def self.email(notification)
        Dallal::Notifiers::EmailNotifier.new(notification)
      end
  
      def self.sms(notification)
        Dallal::Notifiers::SmsNotifier.new(notification)
      end

      def notify!(*args)
        Notifier.api_not_implemented(self)
      end

      def persist!
        Notifier.api_not_implemented(self)
      end
    end
  end
end

require 'dallal/notifiers/email_notifier'
require 'dallal/notifiers/sms_notifier'