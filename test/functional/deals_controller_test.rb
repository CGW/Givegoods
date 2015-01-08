require 'test_helper'

class DealsControllerTest < ActionController::TestCase
  setup do
    @merchant       = merchants(:books_inc)
    @merchant.offer = offers(:books_inc)
    @charity        = charities(:save_the_redwoods_leage)
  end

  should "create with charity and merchant" do
    xhr :post, :create, :merchant_id => @merchant, :charity_id => @charity, "deal" => {"amount_cents" => "5500"}
    assert @deal = assigns(:deal)
    assert_equal "$55.00", @deal.amount.format
    assert_template 'create'
    assert_response :success
    assert cookies[:shopping_basket]
  end

  should "create with charity and bundle" do
    bundle = FactoryGirl.create(:bundle)
    xhr :post, :create, :bundle_id => bundle, :charity_id => bundle.charity, "deal" => {"amount_cents" => "5500"}
    assert @deal = assigns(:deal)
    assert_equal "$55.00", @deal.amount.format
    assert_template 'create'
    assert_response :success
  end

  should "destroy deal" do
    deal = FactoryGirl.create(:deal)
    xhr :delete, :destroy, :id => deal.code
    assert_template 'destroy'
    assert_response :success
    assert cookies[:shopping_basket]
  end
end
