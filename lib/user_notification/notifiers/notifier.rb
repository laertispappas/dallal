require 'user_notification/abstract_interface'
module UserNotification
  module Notifiers
    class Notifier
      include AbstractInterface

      def notify(*args)
        Notifier.api_not_implemented(self)
      end
    end
  end
end

require 'user_notification/notifiers/email_notifier'
