require 'spec_helper'

require 'capybara/rails'
require 'capybara/rspec'
require 'selenium-webdriver'
require "database_cleaner"

# access session from capybara
require "rack_session_access/capybara"

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new

  Capybara::Selenium::Driver.new(app, 
    :browser => :chrome, 
    :profile => profile, 
    :switches => %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate]
  )
end

Capybara.configure do |config|
  config.default_driver = :selenium
  config.default_wait_time = 5
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include CapybaraMatchers,      :type => :request
  config.include Warden::Test::Helpers, :type => :request

  # Clean once before the entire suite.
  config.before :suite, :type => :request do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  # After seems to collide less with concurrent browser actions
  # than cleaning before the tests
  config.after :each, :type => :request do
    Warden.test_reset!
    DatabaseCleaner.clean
  end
end
