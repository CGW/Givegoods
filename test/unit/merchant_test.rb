require 'test_helper'

class MerchantTest < ActiveSupport::TestCase
  should belong_to(:user)
  should have_one(:offer)
  should have_many(:certificates)

  should validate_presence_of   :name
  should validate_presence_of   :website_url
  should validate_acceptance_of :terms_of_service

  should validate_uniqueness_of(:name), :before => lambda { FactoryGirl.create :merchant }

  test "should use address" do
    assert_difference "Merchant.count" do
      assert_difference "MerchantSidekick::Addressable::Address.count" do
        @merchant = Merchant.new(:name => "Goodwolla Inc.", :description => "The home of the biodegradable bio yogurts.",
          :website_url => "http://froyoexample.com")
        @merchant.build_address :first_name => "John", :last_name => "Doe", :address_line_1 => "123 5th St.", :address_line_2 => "Apt. 2a",
          :city => "San Francisco", :zip_code => "94119", :state_code => "CA", :country_code => "US"
        @merchant.save!
      end
    end
  end

  test "should have initial unconfirmed state" do
    merchant = FactoryGirl.create :merchant
    assert_equal :unconfirmed, merchant.aasm_current_state
  end

  test "should set active with user email and website domains matching" do
    merchant = FactoryGirl.create :merchant
    assert_equal "example.com", merchant.send(:website_domain)
    assert_equal "example.com", merchant.send(:user_email_domain)
    assert_equal true, merchant.register!
    assert_equal :active, merchant.aasm_current_state
    merchant.reload
    assert merchant.registered_at, "should set registered_at"
    assert merchant.activated_at, "should set activated_at"
  end

  test "should set pending when user email and website domains are not matching" do
    merchant = FactoryGirl.create :merchant, :website_url => "http://foobar.com", :user => nil
    assert_equal "foobar.com", merchant.send(:website_domain)
    assert_nil merchant.send(:user_email_domain)
    assert_equal true, merchant.register!
    assert_equal :pending, merchant.aasm_current_state
    merchant.reload
    assert merchant.registered_at, "should set registered_at"
  end

  test "scope active_or_owned_by for active merchant" do
    merchant = FactoryGirl.create :merchant
    merchant.register!
    found = Merchant.active_or_owned_by(nil).find(merchant.id)
    assert_equal merchant, found
  end

  test "scope active_or_owned_by for owner" do
    merchant = FactoryGirl.create :merchant
    found = Merchant.active_or_owned_by(merchant.user).find(merchant.id)
    assert_equal merchant, found
  end

  test "scope active_or_owned_by returns none" do
    merchant = FactoryGirl.create :merchant
    assert_raise ActiveRecord::RecordNotFound do
      Merchant.active_or_owned_by(nil).find(merchant.id)
    end
  end
  
  test "should upload picture" do
    merchant = FactoryGirl.create :merchant, 
      :picture => File.open(File.expand_path("#{Rails.root}/test/fixtures/files/merchants/booksinc.png", __FILE__))
    assert_not_nil merchant.picture
    assert_equal false, merchant.picture.blank?
  end

  test "city and state" do
    merchant = merchants(:books_inc)
    assert_equal "Alameda, CA", merchant.city_and_state
  end
  
  should "active to suspended and back to active" do
    merchant = FactoryGirl.create :merchant, :status => "active", :activated_at => Time.now
    assert_equal :active, merchant.aasm_current_state
    assert_equal true, merchant.suspend!
    assert_equal :suspended, merchant.aasm_current_state
    assert_equal true, merchant.unsuspend!
    assert_equal :active, merchant.aasm_current_state
  end

  should "pending to suspended and back to pending" do
    merchant = FactoryGirl.create :merchant, :status => "pending", :registered_at => Time.now
    assert_equal :pending, merchant.aasm_current_state
    assert_equal true, merchant.suspend!
    assert_equal :suspended, merchant.aasm_current_state
    assert_equal true, merchant.unsuspend!
    assert_equal :pending, merchant.aasm_current_state
  end
  
  should "destroy associated user" do
    assert_difference "Merchant.count", -1 do
      assert_difference "User.count", -1 do
        merchants(:powerplant).destroy
      end
    end
  end
  
  should "find merchants with sufficient certificates" do
    merchant = merchants(:books_inc)
    merchant.offer.max_certificates = 5
    merchant.offer.save :validate => false
    certificate = Certificate.create! :merchant => merchant, :amount_cents => 5000, :offer_cap_cents => 10000, :discount_rate => Certificate::DISCOUNT_RATES[0],
      :customer => FactoryGirl.create(:customer), :charity => charities(:alameda_food_bank)
    assert_equal true, Merchant.with_sufficient_budget.include?(merchant)
  end

  should "not find merchants with insufficient certificates" do
    merchant = merchants(:books_inc)
    merchant.offer.max_certificates = 0
    merchant.offer.save :validate => false
    certificate = Certificate.create! :merchant => merchant, :amount_cents => 5000, :offer_cap_cents => 10000, :discount_rate => Certificate::DISCOUNT_RATES[0],
      :customer => FactoryGirl.create(:customer), :charity => charities(:alameda_food_bank)
    assert_equal false, Merchant.with_sufficient_budget.include?(merchant)
  end

  should "create merchant with custom name" do
    merchant = FactoryGirl.build :merchant, :name => "Foobar"
    assert_equal "Foobar", merchant.name
  end

  should "not update merchant name with updating_merchant role" do
    merchant = merchants(:books_inc)
    merchant.update_attributes({:name => "Foobar", :description => "Spencer"}, {:as => :updating_merchant})
    assert_equal "Books Inc.", merchant.name
    assert_equal "Spencer", merchant.description
  end

  should "update merchant name with default role" do
    merchant = merchants(:books_inc)
    merchant.update_attributes({:name => "Foobar", :description => "Spencer"}, {:as => :default})
    assert_equal "Foobar", merchant.name
    assert_equal "Spencer", merchant.description
  end
end
