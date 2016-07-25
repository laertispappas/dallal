class User
  include UserNotification

  #receives_notifications if: :applicable?
end

class OrderWithEmailNotifier
  include UserNotification

  add_notifier
end

class OrderWithIncludedUserNotificationModule
  include UserNotification
end

class OrderWithEmailAndSmsNotifier
  include UserNotification
end
