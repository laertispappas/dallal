module UserNotification
  class Engine < ::Rails::Engine
    isolate_namespace UserNotification
    
    initializer "Include UserNotification after rails boot" do
      require 'user_notification/file_loader'

      # Run before every request in dev and before the first request in production
      ActionDispatch::Callbacks.to_prepare do
        UserNotification::FileLoader.load_notifiers
      end
    end

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
