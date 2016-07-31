# TODO Fix these

class Base
  def self.after_create *args
  end

  def self.after_update *args
  end
end

class Person < Base
  include UserNotification

  #receives_notifications if: :applicable?
end

class OrderWithEmailNotifier < Base
  include UserNotification

  add_notifier
end

class OrderWithIncludedUserNotificationModule < Base
  include UserNotification
end

class OrderWithEmailAndSmsNotifier < Base
  include UserNotification
end
