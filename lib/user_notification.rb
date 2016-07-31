require "user_notification/engine" if defined?(Rails)
require 'user_notification/notification'
require 'user_notification/notifiers/notifier'
require 'user_notification/events/events'
require 'user_notification/notifiable'
require 'user_notification/configuration'

module UserNotification
  extend Configuration
  # Add here include Notifiable and move all methods below to
  # Notifiable Module

  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)

    # Notifiable module for Pub events
    base.include(UserNotification::Notifiable)
  end

  module ClassMethods
  end

  module InstanceMethods
    def notifiers
      self.class.notifiers
    end

    def notify(template, user)
      notifiers.each do |_, notifier|
        notifier.notify(template, user)
      end
    end
  end
end
