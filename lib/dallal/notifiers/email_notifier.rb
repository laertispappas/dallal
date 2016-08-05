module Dallal
  module Notifiers
    class EmailNotifier < Notifier
      def notify!
        mailer.notify(notification).deliver_now
      end

      def persist!
      end

      private

      def mailer
        Dallal::Mailer
      end
    end
  end
end
