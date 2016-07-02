require 'singleton'

module UserNotification
  module Notifiers
    class EmailNotifier < Notifier
      include Singleton

      def notify(*args)
      end
    end
  end
end
