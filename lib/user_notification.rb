require "user_notification/engine" if defined?(Rails)
require 'user_notification/notification'
require 'user_notification/notifiers/notifier'
require 'user_notification/events/events'
require 'user_notification/configuration'
require 'user_notification/events/event_publisher'

module UserNotification
  extend Configuration
  # Add here include Notifiable and move all methods below to
  # Notifiable Module

  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
    
    base.class_eval do
      include UserNotification::Events::Publisher

      after_create :publish_notification_created
      after_update :publish_notification_updated
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def publish_notification_created
      UserNotification::Events::EventPublisher.broadcast({
        class: self.class.name, id: self.id, event: :create
      })
    end

    def publish_notification_updated
      UserNotification::Events::EventPublisher.broadcast({
        class: self.class.name, id: self.id, event: :update
      })
    end
  end
end
