require 'singleton'

module UserNotification
  module Notifiers
    class EmailNotifier < Notifier
      include Singleton

      def notify(template, user, *args)
        #options = args.extract_options!
      end
    end
  end
end
