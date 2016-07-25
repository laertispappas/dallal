module UserNotification
  module Generators
    class InstallGenerator < ::Rails::Generators::Base 
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      
      def copy_initializer
         template 'user_notification.rb', 'config/initializers/user_notification.rb'
      end
    end
  end
end
