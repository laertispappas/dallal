require 'rails/generators/active_record'

module Dallal
  module Generators
    class NotificationGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def notifications_table_name
        "#{table_name.singularize}_notifications"
      end

      def copy_migration
        migration_template "migration.rb", "db/migrate/create_#{notifications_table_name}.rb"
      end

      def copy_files
        copy_file "model.rb", model_path

        if self.behavior == :invoke
          inject_into_class(model_path, model_class_name, model_content)
        end
      end

      private
      def model_class_name
        "#{table_name.singularize}_notification".classify
      end

      def user_model_name
        Dallal.configuration.user_class_name.downcase
      end

      def model_path
        "app/models/#{table_name.singularize}_notification.rb"
      end

      def model_content
        <<-TEXT
  belongs_to #{user_model_name}
        TEXT
      end
    end
  end
end
