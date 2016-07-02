require 'ostruct'

module UserNotification
  module Configuration
    CURRENT_ATTRS = [:user_class_name].freeze
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

    def confguration
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

      private
      def set_default_values
        self.user_class_name = 'User'
      end
    end
  end
end
