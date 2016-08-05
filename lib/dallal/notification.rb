require 'dallal/notifications/email_notification'
require 'dallal/notifications/sms_notification'

module Dallal
  class Notification
    attr_accessor :event, :model_class, :opts, :_object
    attr_reader :template_name

    def initialize args = {}
      args.each do |k, v|
        send("#{k}=", v)
      end

      @notifiers = []
    end

    # TODO Collection of targets is not supported
    def notify *args, &block
      notify_opts = args.extract_options!
      return unless should_send?(notify_opts[:if])

      @targets = Array(args).flatten.compact.uniq
      instance_eval(&block)
    end

    def with *args, &block
      opts = args.extract_options!
      return unless should_send?(opts[:if])

      instance_eval(&block)
      # create a notifier for each target
      @targets.each do |target|
        args.each do |name|
          @notifiers << get_notifier(name, target)
        end
      end
    end

    # TODO !!! Watch out same payload for multiple notifers that
    # require payload
    def payload payload
      @payload = payload
    end

    # Same here as payload
    def template template
      @template_name = template
    end

    def persist?
      opts[:persist].present?
    end

    def dispatch!
      validate!
      @notifiers.each { |n| n.notify! }
      @notifiers.each { |n| n.persist! } if persist?
    end

    private
    # TODO Implement this
    # when target is nil throw error
    # on email notification when template is nil throw error
    # on sms notification when payload is nil throw an error
    # on any other notifiers add a validation logic here
    def validate!
      if false
        raise "You have not defined \'notify\' in \'with\' block for #{class_name} notifier"
      end
    end

    def get_notifier(name, target)
      notification = "Dallal::Notifications::#{name.to_s.camelcase}Notification".constantize.new(self, target)
      Dallal::Notifiers::Notifier.send(name, notification)
    end

    def should_send?(condition)
      return true if condition.blank?

      if condition.is_a?(Proc)
        instance_exec(&condition)
      else
        _object.send(condition)
      end
    end
  end
end
