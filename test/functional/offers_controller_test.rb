require 'test_helper'

class OffersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "index" do
    get :index
    assert_template 'index'
    assert_response :success
    assert assigns(:offers)
  end

  test "show" do
    offer = FactoryGirl.create(:offer)
    get :show, :id => offer
    assert_template 'show'
    assert_response :success
    assert assigns(:offer)
  end
end
