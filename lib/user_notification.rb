require "user_notification/engine"
require 'user_notification/configuration'
require 'user_notification/notifiers/notifier'


module UserNotification
  extend Configuration


  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def notifiers
      @notifiers ||= {}
    end

    def add_notifier(&block)
      if block_given?
        instance_eval(&block)
      else
        add_default_notifier
      end
    end

    private
    def add_default_notifier
      email
    end

    def sms
      @__sms_notifier ||= UserNotification::Notifiers::Notifer.sms
      self.notifiers[:sms] ||= @__sms_notifier
    end

    def email
      @__email_notifier ||= UserNotification::Notifiers::Notifier.email
      self.notifiers[:email] ||= @__email_notifier
    end
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
