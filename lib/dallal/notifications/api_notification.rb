require 'dallal/notifications/base_notification'

module Dallal
  module Notifications
    class ApiNotification < BaseNotification
      attr_reader :method, :client, :path, :payload

      def initialize(notification, target)
        super(notification, target)
      end

      # both setter and getter
      def payload payload = nil
        if payload.present?
          @payload = payload
        else
          @payload
        end
      end

      def path path = nil
        if path.present?
          @path = path
        else
          @path
        end
      end

      def method http_verb = nil
        if http_verb.present?
          @method = http_verb
        else
          @method
        end
      end

      def client client = nil
        if client.present?
          @client = client
        else
          @client
        end
      end

      def notifier
        Dallal::Notifiers::ApiNotifier.new(self)
      end
    end
  end
end