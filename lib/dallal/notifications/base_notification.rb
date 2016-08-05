module Dallal
  module Notifications
    class BaseNotification
      attr_reader :target

      def initialize(notification, target)
        @notification = notification
        @target = target
      end

      def method_missing(name, *args, &block)
        if @notification.respond_to?(name)
          @notification.send(name, *args, &block)
        else
          super
        end
      end

      def respond_to?(method_name, include_private=true)
        @notification.respond_to?(method_name) || super
      end

    end
  end
end
