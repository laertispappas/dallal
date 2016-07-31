require 'ostruct'

module UserNotification
  module Configuration
    CURRENT_ATTRS = [:user_class_name, :user_notification_class_name, :enabled].freeze
    DEPRECATED_ATTRS = [].freeze
    CONFIG_ATTRS = (CURRENT_ATTRS + DEPRECATED_ATTRS).freeze

    def config
      @config ||= Configuration.new
    end
    private :config

    def configure
      return unless block_given?
      yield config if block_given?
    end

    def configuration
      config
    end

    def options
      config.options
    end

    class Configuration < Struct.new(*CONFIG_ATTRS)
      def initialize
        super

        set_default_values
      end

      def options
        Hash[ * CONFIG_ATTRS.map { |key| [key, send(key)] }.flatten ] 
      end

      def enabled?
        self.enabled
      end

      private
      def set_default_values
        self.user_class_name = 'User'
        self.user_notification_class_name = 'UserNotification'
        self.enabled = true
      end
    end
  end
end
