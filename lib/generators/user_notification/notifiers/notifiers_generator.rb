require 'rails/generators/active_record'

module UserNotification
  module Generators
    class NotifiersGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      
      def copy_migration
        migration_template "#{notifier_name}_notifier_migration.rb", "db/migrate/create_#{notifier_name}_notifiers.rb"
      end

      # TODO Refactor and DRY this or better DRY 3 step generation process into 1 or 2. 
      def copy_files
        copy_file "#{notifier_name}_notifier.rb", model_path

        if self.behavior == :invoke
          inject_into_class(model_path, model_class_name, model_content)
        end
      end
    
      def user_notification_class_name
        UserNotification.configuration.user_notification_class_name.underscore
      end

      private
      def notifications_table_name
        "#{notifier_name}_notifiers"
      end

      # A quick and dirty patch for sms -> sm singularization
      def notifier_name
        case table_name
        when 'sms'
          # TODO Revisit this one. sms name [singularizes as sm]
          'sms'
        else
          table_name.singularize
        end
      end

      def model_class_name
        "#{notifier_name}_notifier".classify
      end

      def model_content
        <<-RUBY
  belongs_to #{user_notification_class_name}
        RUBY
      end

      def model_path
        "app/models/#{notifier_name}_notifier.rb"
      end
    end
  end
end
