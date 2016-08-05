require 'ostruct'

module Dallal
  module Configuration
    CURRENT_ATTRS = [:user_class_name, :dallal_class_name, :enabled,
                     :email_layout, :from_email, :from_name,
                     :twilio_account_id, :twilio_auth_token, :sms_from].freeze
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
        # App config
        self.user_class_name = 'User'
        self.dallal_class_name = 'Dallal'
        self.enabled = true

        # Email config
        self.email_layout = 'mailer'
        self.from_email = 'foo@bar.xyz'
        self.from_name = 'just a name'

        # SMS config
        self.twilio_account_id = 'YOUR TWILIO ACCOUNT ID'
        self.twilio_auth_token = 'TWILIO_AUTH_TOKEN'
        self.sms_from = 'Sender phone number'
      end
    end
  end
end
