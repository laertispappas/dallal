require "dallal/engine" if defined?(Rails)
require 'dallal/configuration'
require 'dallal/notification'
require 'dallal/notifiers/notifier'
require 'dallal/events/events'
require 'dallal/events/event_publisher'
require 'twilio-ruby'

module Dallal
  extend Configuration
  # Add here include Notifiable and move all methods below to
  # Notifiable Module

  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
    
    base.class_eval do
      include Dallal::Events::Publisher

      after_create :publish_notification_created
      after_update :publish_notification_updated
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def publish_notification_created
      Dallal::Events::EventPublisher.broadcast({
        class: self.class.name, id: self.id, event: :create
      })
    end

    def publish_notification_updated
      Dallal::Events::EventPublisher.broadcast({
        class: self.class.name, id: self.id, event: :update
      })
    end
  end
end
