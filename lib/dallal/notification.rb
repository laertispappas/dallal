require 'dallal/notifications/email_notification'
require 'dallal/notifications/sms_notification'

module Dallal
  class Notification
    attr_accessor :event, :model_class, :opts, :_object
    attr_reader :targets
    attr_reader :notifiers

    def initialize args = {}
      args.each do |k, v|
        send("#{k}=", v)
      end

      @notifiers = []
    end

    def notify *args, &block
      notify_opts = args.extract_options!
      return unless should_send?(notify_opts[:if])

      @targets = Array(args).flatten.compact.uniq
      instance_eval(&block)
    end

    def with *args, &block
      opts = args.extract_options!
      return unless should_send?(opts[:if])

      # create a notifier for each target
      @targets.each do |target|
        args.each do |name|
          notifier = get_notifier(name, target, &block)
          @notifiers << notifier
        end
      end
    end

    def persist?
      opts[:persist].present?
    end

    def dispatch!
      validate!
      @notifiers.each do |notifier|
        # notifier.validate!
        notifier.notify!
      end
      @notifiers.each { |n| n.persist! } if persist?
    end

    private
    # TODO Implement this
    # Add validation logic here
    def validate!
      if false
        raise "You have not defined \'notify\' in \'with\' block for #{class_name} notifier"
      end
    end

    def get_notifier(name, target, &block)
      notification = "Dallal::Notifications::#{name.to_s.camelcase}Notification".constantize.new(self, target)
      notification.instance_eval(&block)
      notification.notifier
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
