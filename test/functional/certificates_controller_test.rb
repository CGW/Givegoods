require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  should "redirect on show when not signed in" do
    get :show
    assert_response :redirect
  end

  context "a get show" do
    setup do
      sign_in users(:homer)
      get :show
    end

    should "respond ok" do
      assert_response :success
    end

    should "match body[class]" do
      assert_select "body[class]", true
    end
  end
end
