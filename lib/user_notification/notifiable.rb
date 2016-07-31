require 'user_notification/events/event_publisher'

module UserNotification
  module Notifiable
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)

      base.class_eval do
        include UserNotification::Events::Publisher

        after_create :publish_notification_created
        after_update :publish_notification_updated
      end
    end

    module ClassMethods
      def notifiers
        @notifiers ||= {}
      end

      def add_notifier(&block)
        if block_given?
          instance_eval(&block)
        else
          add_default_notifier
        end
      end

      private
      def add_default_notifier
        email
      end

      def sms
        @__sms_notifier ||= UserNotification::Notifiers::Notifier.sms
        self.notifiers[:sms] ||= @__sms_notifier
      end

      def email
        @__email_notifier ||= UserNotification::Notifiers::Notifier.email
        self.notifiers[:email] ||= @__email_notifier
      end

    end

    module InstanceMethods
      def publish_notification_created
        UserNotification::Events::EventPublisher.broadcast({
          class: self.class.name, id: self.id, event: :create
        })
      end

      def publish_notification_updated
        UserNotification::Events::EventPublisher.broadcast({
          class: self.class.name, id: self.id, event: :update
        })
      end
    end

  end
end
