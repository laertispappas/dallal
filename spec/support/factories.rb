class OrderWithEmailNotifier
  include UserNotification

  add_notifier
end

class OrderWithIncludedUserNotificationModule
  include UserNotification
end
