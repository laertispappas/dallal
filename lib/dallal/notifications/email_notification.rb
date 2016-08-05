require 'dallal/notifications/base_notification'
module Dallal
  module Notifications
    class EmailNotification < BaseNotification
      attr_reader :from_name, :from_email

      def initialize(notification, target)
        super(notification, target)

        @from_name = Dallal.configuration.from_name
        @from_email = Dallal.configuration.from_email
      end
    end
  end
end
