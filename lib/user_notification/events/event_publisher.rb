module UserNotification
  module Events
    class EventPublisher
      include UserNotification::Events::Publisher
      self.pub_sub_namespace = 'user_notifications'
    end
  end
end
