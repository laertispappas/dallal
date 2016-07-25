require "user_notification/engine"
require 'user_notification/configuration'
require 'user_notification/notifiers/notifier'

module UserNotification
  extend Configuration


  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
    
    base.notifiers[base.name] ||= []
  end

  module ClassMethods
    def notifiers
      @notifiers ||= {}
    end

    def add_notifier(&block)
      unless block_given?
        add_default_notifier
      else
        instance_eval(&block)
      end
    end

    private
    def add_default_notifier
      email
    end

    def sms
      unless self.notifiers[self.name].include?(@__sms_notifier)
        @__sms_notifier ||= UserNotification::Notifiers::Notifier.sms
        self.notifiers[self.name] << @__sms_notifier
      end
    end

    def email
      unless self.notifiers[self.name].include?(@__email_notifier)
        @__email_notifier ||= UserNotification::Notifiers::Notifier.email
        self.notifiers[self.name] << @__email_notifier
      end
    end
  end

  module InstanceMethods
    def notifiers
      self.class.notifiers[self.class.name]
    end

    def notify(template, user)
      notifiers.each do |notifier|
        notifier.notify(template, user)
      end
    end
  end
end
