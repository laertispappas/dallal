module Dallal
  class FileLoader
    def self.load_notifiers
      if directory_exists?
        Dir[Rails.root.join("app/notifiers/**/*.rb")].each do |file|
          require_dependency file
        end
      end
    end

    def self.directory_exists?
      File.directory?(Rails.root.join("app/notifiers"))
    end
  end
end
