module UserNotification
  class Notification
    attr_accessor :event, :model_class, :opts, :_object
    def initialize args = {}
      args.each do |k, v|
        send("#{k}=", v)
      end
    end

    def dispatch!
    end
  end
end
