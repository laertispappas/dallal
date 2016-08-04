$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dallal/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dallal"
  s.version     = Dallal::VERSION
  s.authors     = ["Laertis Pappas"]
  s.email       = ["laertis.pappas@gmail.com"]
  s.homepage    = "https://github.com/laertispappas/dallal"
  s.summary     = "A Rails engine to add any kind of notification to your app. Currently supports only email notification."
  s.description = "Dallas provides a DSL that allows you to define and create notifications for any kind of target. Currently it supports only create and update actions of a resource and only email notifications."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
