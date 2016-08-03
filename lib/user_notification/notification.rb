module UserNotification
  class Notification
    attr_accessor :event, :model_class, :opts, :_object

    def initialize args = {}
      args.each do |k, v|
        send("#{k}=", v)
      end

      @notifiers = {}
    end

    def notify target, &block
      @target = Array(target).flatten.compact.uniq
      instance_eval(&block)
    end

    def with *args, &block
      opts = args.extract_options!
      if should_send?(opts[:if])
        instance_eval(&block)
        args.each { |arg| @notifiers[arg] = get_notifier(arg) }
      end
    end

    # TODO !!! Watch out same payload for multiple notifers that 
    # require payload
    def payload payload
      @payload = payload
    end

    # Same here as payload
    def template template
      @template = template
    end

    def persist?
      opts[:persist].present?
    end

    # TODO Rethink this. Not all notifiers have push functionality
    def dispatch!
      validate!
      @notifiers.each { |_, n| n.notify! }
      @notifiers.each { |_, n| n.persist! } if persist?
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

    def get_notifier(name)
      UserNotification::Notifiers::Notifier.send(name, self)
    end

    def should_send?(condition)
      return true if condition.blank?

      if condition.is_a?(Proc)
        _object.instance_exec(&condition)
      else
        _object.send(condition)
      end
    end
  end
end
