require 'test_helper'

class Users::OmniauthCallbacksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "get facebook callback with existing user" do
    user = FactoryGirl.create(:fbuser)
    User.expects(:find_or_create_from_facebook_oauth).returns(user)
    User.any_instance.stubs(:persisted?).returns(true)
    get :facebook
    assert assigns(:user)
    assert_response 302
  end

  test "get facebook callback with validation errors" do
    user = FactoryGirl.create(:fbuser)
    User.expects(:find_or_create_from_facebook_oauth).returns(user)
    User.any_instance.stubs(:persisted?).returns(false)
    get :facebook
    assert assigns(:user)
    assert_response :success
    assert_template 'new'
  end
end
