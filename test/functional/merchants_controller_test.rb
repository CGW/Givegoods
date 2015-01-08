require 'test_helper'

class MerchantsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  should "get index" do
    get :index
    assert_template 'index'
    assert_response :success
    assert assigns(:merchants)
  end

  should "redirect on show without charity" do
    get :show, :id => merchants(:burma_superstar)
    assert_redirected_to merchants_path
  end

  should "get show with charity" do
    get :show, :charity_id => charities(:save_the_redwoods_leage), :id => merchants(:books_inc)
    assert_template 'show'
    assert_response :success
    assert assigns(:merchant)
    assert assigns(:charity)
  end

  should "get new" do
    sign_in FactoryGirl.create(:user)
    get :new
    assert_template 'new'
    assert_response :success
    assert assigns(:merchant)
  end

  should "get new with merchant" do
    merchant = FactoryGirl.create(:merchant)
    sign_in merchant.user
    get :new
    assert_redirected_to edit_user_merchant_url
  end

  should "not create invalid" do
    sign_in FactoryGirl.create(:user)
    Merchant.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
    assert_response :success
    assert assigns(:merchant)
  end

  should "create valid" do
    sign_in FactoryGirl.create(:user)
    Merchant.any_instance.stubs(:valid?).returns(true)
    post :create
    assert assigns(:merchant)
    assert_redirected_to edit_user_merchant_url
  end

  should "get edit" do
    merchant = FactoryGirl.create(:merchant)
    sign_in merchant.user
    get :edit
    assert_template 'edit'
    assert_response :success
    assert assigns(:merchant)
  end

  should "not update invalid" do
    merchant = FactoryGirl.create(:merchant)
    sign_in merchant.user
    Merchant.any_instance.stubs(:save).returns(false)
    put :update
    assert assigns(:merchant)
    assert !assigns(:merchant).valid?
    assert_template 'edit'
    assert_response :success
  end

  should "update valid" do
    merchant = FactoryGirl.create(:merchant)
    sign_in merchant.user
    Merchant.any_instance.stubs(:save).returns(true)
    put :update
    assert_redirected_to edit_user_merchant_url
    assert assigns(:merchant)
  end

  should "get search" do
    get :search, :place => "Alameda, CA"
    assert_template 'index'
    assert_response :success
    assert @merchants = assigns(:merchants)
  end
end
