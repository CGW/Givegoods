require 'test_helper'

class CharitiesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  should "get index" do
    get :index
    assert_template 'index'
    assert_response :success
    assert assigns(:charities)
  end

  should "get index with merchant" do
    get :index, :merchant_id => merchants(:books_inc)
    assert_template 'index'
    assert_response :success
    assert assigns(:merchant)
    assert assigns(:charities)
  end

  should "redirect on show without merchant" do
    get :show, :id => charities(:boys_and_girls_of_alameda)
    assert_redirected_to charities_path
  end

  should "get show with merchant" do
    charity = FactoryGirl.create(:charity)
    get :show, :merchant_id => merchants(:books_inc), :id => charities(:save_the_redwoods_leage)
    assert_template 'show'
    assert_response :success
    assert assigns(:charity)
    assert assigns(:merchant)
  end
end
