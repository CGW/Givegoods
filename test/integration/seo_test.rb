require 'test_helper'

class SeoTest < ActionDispatch::IntegrationTest
  test "there should be a rewards url" do
    get "/rewards"
    assert_response :ok
  end

  test "pages should have a meta description" do
    get "/pages/about"
    assert_select "meta[name=description][content=?]", I18n.t("site.meta_description")
  end

  test "rewards title" do
    get "/rewards"
    assert_select "title", "Rewards :: #{I18n.t("site.title")}"
  end

  test "about title" do
    get "/pages/about"
    assert_select "title", "About :: #{I18n.t("site.title")}"
  end

  test "charities title" do
    get "/charities"
    assert_select "title", "Charities :: #{I18n.t("site.title")}"
  end

  test "signup title" do
    get "/users/sign_up"
    assert_select "title", "Sign Up :: #{I18n.t("site.title")}"
  end

  test "charity page title" do
    get merchant_charity_path(:merchant_id => merchants(:books_inc), :id => charities(:save_the_redwoods_leage))
    assert_select "title", "Save The Redwoods League :: #{I18n.t("site.title")}"
  end

  test "charity merchants page title" do
    get charity_merchants_path(:charity_id => charities(:save_the_redwoods_leage))
    assert_select "title", "Save The Redwoods League :: #{I18n.t("site.title")}"
  end

  test "merchant page title" do
    get merchant_charities_path(:merchant_id => merchants(:books_inc).to_param)
    assert_select "title", "Books Inc. :: #{I18n.t("site.title")}"
  end
end
