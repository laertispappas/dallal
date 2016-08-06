Dallal.configure do |config|
  # Set the user class name of your app
  # config.user_class_name  = 'User'

  # Set up user notification class name
  # config.dallal_class_name = 'DallalNo'

  # Enable / Disable notifications globally
  config.enabled = true

  # Email config
  config.email_layout = 'mailer'
  config.from_email = 'info@yourdomain.com'
  config.from_name = 'System Display Name'

  # Twulio SMS configuration
  config.twilio_account_id = 'YOUR TWILIO ACCOUNT ID'
  config.twilio_auth_token = 'YOUR TWILIO_AUTH_TOKEN'
  config.sms_from = 'Your Twilio phone phone number'
end
