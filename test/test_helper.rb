if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start 'rails'
end

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # HACK, see: http://stackoverflow.com/questions/3118866/mocha-mock-carries-to-another-test
  def teardown
    super
    Mocha::Mockery.instance.teardown
    Mocha::Mockery.reset_instance
  end

  def transaction
    ActiveRecord::Base.connection.transaction do
      yield
      raise ActiveRecord::Rollback
    end
  end

  # Sample omniauth data
  OMNIAUTH_DATA = {
    "expires" => true,
    "expires_at" => 1323986400,
    "token" => "Blah..blah..blah",
    "extra" => {
      "raw_info" => {
        "email"        => "bart@example.com",
        "first_name"   => "Bart",
        "gender"       => "male",
        "id"           => "44827546986",
        "last_name"    => "Simpson",
        "link"         => "http://www.facebook.com/bart",
        "locale"       => "en_US",
        "name"         => "Bart Simpson",
        "timezone"     => -5,
        "updated_time" => "2011-11-24T19:52:19+0000",
        "username"     => "bart.simpson",
        "verified"     => true,
      },
    },
    "info" => {
      "email"      => "bart@example.com",
      "first_name" => "Bart",
      "image"      => "http://profile.ak.fbcdn.net/hprofile-ak-snc4/41786_44827546986_2797_s.jpg",
      "last_name"  => "Simpson",
      "name"       => "Bart Simpson",
      "nickname"   => "bart.simpson",
      "urls"       =>  {
        "Facebook" => "http://www.facebook.com/pages/Bart-Simpson/44827546986",
      },
      "provider"   => "facebook",
      "uid"        => "44827546986",
    }
  }

end

# class ActionDispatch::IntegrationTest
#   def sign_in(user)
#     post user_session_url, :user => {
#       :email    => user.email,
#       :password => SocialBuilder.env[:defaults][:manager][:password]
#     }
#     assert_redirected_to root_url
#   end
# end
# test/shoulda_macros/validation_macros.rb
module ActiveSupport
  class TestCase
    include Shoulda::Matchers::ActiveModel
    extend Shoulda::Matchers::ActiveModel
    include Shoulda::Matchers::ActiveRecord
    extend Shoulda::Matchers::ActiveRecord

    def assert_error_on(record, *fields)
      record.valid?
      fields.each do |field|
        assert !record.errors[field.to_sym].empty?, "expected errors on #{field}"
      end
    end

    def assert_no_error_on(record, *fields)
      record.valid?
      fields.each do |field|
        assert record.errors[field.to_sym].empty?, "expected no errors on #{field}"
      end
    end
  end
end

# TODO set up better mocking for this
require File.expand_path("../../lib/give_goods/geocoder", __FILE__)
module GiveGoods
  class Geocoder
    def initialize(arg)
      @lat    = 0
      @lng    = 0
      @ne     = [0, 0]
      @sw     = [0, 0]
      @city   = "Anywhere"
      @region = "CA"
      @query  = arg
    end
  end
end

CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end

class ActionDispatch::IntegrationTest
  def sign_in_as_admin
    email    = "test@givegoods.org"
    password = "this is the password"
    AdminUser.find_or_create_by_email email, password: password, password_confirmation: password
    post admin_user_session_url, admin_user: {email: email, password: password}
  end
end

# Wrap assert_select assertions with silence_warnings blocks. Remove this code
# once the views are fixed and valid. See issue #145.
ActionDispatch::Assertions::SelectorAssertions.class_eval do
  def assert_select_with_silence_warnings(*args, &block)
    silence_warnings do
      assert_select_without_silence_warnings(*args, &block)
    end
  end
  alias_method_chain :assert_select, :silence_warnings
end
