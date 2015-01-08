require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "get index aka homepage" do
    get :index
    assert_response :ok
  end

  test "get show with valid template" do
    get :show, :page => 'terms-and-conditions'
    assert_response :ok
    assert_template 'terms-and-conditions'
  end

  test "get show with invalid template" do
    get :show, :page => 'non-existing-template'
    assert_response 404
  end
end
