module UserNotification
  module Result
    class Success
      attr_reader :success, :data
      def initialize(data = nil)
        @success = true
        @data = data
      end
    end

    class Error
      attr_reader :success, :message, :data

      def initialize(message, data = nil)
        @success = false
        @message = message
        @data = data
      end
    end
  end
end
