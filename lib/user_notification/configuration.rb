require 'ostruct'

module UserNotification
  CURRENT_ATTRS = [:user_class_name].freeze
  DEPRECATED_ATTRS = [].freeze
  CONFIG_ATTRS = (CURRENT_ATTRS + DEPRECATED_ATTRS).freeze

  class << self
    def config
      @config ||= UserNotification::Configuration.new
    end

    def configure
      return unless block_given?
      yield config if block_given?
    end

    def options
      config.options
    end
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
