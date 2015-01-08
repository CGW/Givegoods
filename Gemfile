source 'http://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.1'
  gem "bootstrap-sass", "~> 2.1.1.0"
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
  gem 'knockoutjs-rails'
end

gem 'devise', '~> 1.5.3'
gem "omniauth-facebook"
gem 'yettings'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
#gem 'unicorn'

gem "thin"

group :development do
  gem 'quiet_assets'

  gem 'heroku_san'
  gem 'foreman'
end

group :test do
  gem 'simplecov'
  gem 'mocha'
  gem 'shoulda', '~> 3.0.1'
  gem 'factory_girl_rails', '~> 3.0'

  gem "capybara", "~> 1.1.2"
  
  # for session access in feature tests
  gem 'rack_session_access'
  gem "database_cleaner", "~> 0.8.0"
end

group :test, :development do
  gem "execjs"
  gem "debugger", :require => false
  gem "awesome_print", :require => 'ap'

  gem "rspec-rails", "~> 2.11.0"
end

group :production do
  gem "therubyracer"
end

gem 'pg'
gem "money"
gem "friendly_id", "~> 4.0.0"
gem "attribute_normalizer"
gem 'virtus' 
gem 'fog'
gem 'carrierwave', "~> 0.6.2"
gem 'mini_magick'
gem 'chunky_png'
gem "merchant_sidekick", :git => "git://github.com/givegoods/merchant_sidekick.git", :ref => '3ac5bc9bc6be009f17e24bf551bb31ab439df036'
gem "ambry"
gem "rake", "0.9.3.beta.1"
gem "aasm"

gem "dynamic_form"
gem "formtastic", "~> 2.1.1"
gem "activeadmin", "~> 0.4.3"

gem 'meta_search',    '>= 1.1.0.pre'
gem "kaminari"
gem "rails3-jquery-autocomplete"
gem 'haml-rails'
gem 'newrelic_rpm'
gem 'rack-ssl', require: "rack/ssl"
