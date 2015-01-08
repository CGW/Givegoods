require 'test_helper'

class ConsumerStoriesTest < ActionDispatch::IntegrationTest
  context "a new user" do
    should "get homepage" do
      get root_url
      assert_response :ok
    end

    should "register merchant" do
      get new_user_registration_path
      assert_response :success
      post_via_redirect user_registration_path,
        "user" => {
          "first_name"            => "Pepe",
          "last_name"             => "Grillo",
          "email"                 => "pepe@grillo.com",
          "password"              => "[FILTERED]",
          "password_confirmation" => "[FILTERED]",
          "merchant_attributes"   => {
            "name"        => "Pinochio",
            "website_url" => "http://pinochio.com/",
            "address_attributes" => {
              "state_code"   => "CA",
              "city"         => "San Francisco",
              "zip_code"     => "90210",
              "country_code" => "US"
            }
          }
        }
      assert_response :success
      assert_equal path, user_confirmation_sent_path
      assert_nil flash[:notice]
    end
  end
end
