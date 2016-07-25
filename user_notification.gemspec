$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "user_notification/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "user_notification"
  s.version     = UserNotification::VERSION
  s.authors     = ["Laertis Pappas"]
  s.email       = ["laertis.pappas@gmail.com"]
  s.homepage    = "http://github.com/laertispappas"
  s.summary     = "Summary of UserNotification."
  s.description = "Description of UserNotification."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
