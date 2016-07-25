
module UserNotification
  module Notifiers
    class SmsNotifier < Notifier

      def notify(template, user, *args)
        #options = args.extract_options!
      end
    end
  end
end
