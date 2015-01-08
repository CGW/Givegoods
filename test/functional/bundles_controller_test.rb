require 'test_helper'

class BundlesControllerTest < ActionController::TestCase
  setup do
    @bundle = bundles(:boys_and_girls_of_alameda)
  end

  test "should redirect on show" do
    get :show, :charity_id => @bundle.charity, :id => @bundle
    assert_redirected_to @bundle.charity
  end

  test "should get show as js" do
    get :show, :charity_id => @bundle.charity, :id => @bundle, :format => :js
    assert_response :success
    assert_equal @bundle.charity, assigns(:charity)
    assert_equal @bundle, assigns(:bundle)
  end
end
