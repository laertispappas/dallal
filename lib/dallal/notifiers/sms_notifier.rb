
module Dallal
  module Notifiers
    class SmsNotifier < Notifier

      class << self
        def client
          @client ||= Twilio::REST::Client.new(
            Dallal.configuration.twilio_account_id,
            Dallal.configuration.twilio_auth_token)
        end
      end

      def notify!
        client.messages.create(from: notification.from,
                               to: notification.to,
                               body: notification.body)
      end

      def persist!
      end

      def client
        self.class.client
      end

      private
    end
  end
end
