require 'singleton'

module UserNotification
  module Notifiers
    class EmailNotifier < Notifier
      include Singleton

      def notify(template, user, *args)
      end

      def mailer
      end
    end
  end
end
