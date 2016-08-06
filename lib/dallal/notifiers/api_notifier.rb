require 'dallal/notifiers/http_client'

module Dallal
  module Notifiers
    class ApiNotifier < Notifier

      def notify!
        if notification.client.present?
          notification.client.new(notification).notify!
        else
          client.send(notification.method, notification.path, notification.payload)
        end
      end

      def persist!
      end

      def client
        Dallal::Notifiers::HttpClient.new
      end
    end
  end
end