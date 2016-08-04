Dallal.configure do |config|
  # Set the user class name of your app
  config.user_class_name  = 'User'

  # Set up user notification class name
  config.dallal_class_name = 'Dallal'

  # Enable / Disable notifications globaly
  config.enabled = true

  # 
  # config.available_notifications = [:email]

  # 
  # config.auto_deliver = true
end
