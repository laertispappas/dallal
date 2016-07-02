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
        raise NotImplementedError
      end
    end

    private
    def add_default_notifier
      notifiers[self.name] << UserNotification::Notifiers::EmailNotifier.instance
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
