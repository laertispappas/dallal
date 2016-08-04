module Dallal
  module Generators
    class InstallGenerator < ::Rails::Generators::Base 
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      
      def copy_initializer
         template 'dallal.rb', 'config/initializers/dallal.rb'
      end
    end
  end
end
