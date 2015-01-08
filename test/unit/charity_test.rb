require 'test_helper'

class CharityTest < ActiveSupport::TestCase
  should have_many(:offers)
  should have_many(:certificates)
  should have_many(:bundles)
  should have_and_belong_to_many(:blocked_merchants)
  should have_many(:donations)
  should have_many(:purchase_orders)
  should have_one(:address)

  test "should use address" do
    transaction do
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
  end

  test "should upload picture" do
    charity = FactoryGirl.create :charity,
      :picture => File.open(File.expand_path("#{Rails.root}/test/fixtures/files/charities/save-the-redwoods.jpg", __FILE__))
    assert_not_nil charity.picture
    assert_equal false, charity.picture.blank?
  end

  test "city and state" do
    charity = charities(:save_the_redwoods_leage)
    assert_equal "San Francisco, CA", charity.city_and_state
  end

  test "close_to should sort named city first regardless of coordinates" do
    transaction do
      name = rand(10e10).to_s(36)
      Charity.create!({
        :name => name,
        :lat  => "37.8046",
        :lng  => "-122.2699",
        :address_attributes => {:city => "Piedmont", :state_code => "CA", :country_code => "US"}
      })
      Charity.create!({
        :name => name,
        :lat  => "37.735472",
        :lng  => "-122.3007",
        :address_attributes => {:city => "Oakland", :state_code => "CA", :country_code => "US"}
      })
      geo       = OpenStruct.new
      geo.box   = [37.88472489999999, -122.1149234, 37.699192, -122.3426649]
      geo.city  = "Oakland"
      geo.state = "CA"
      assert_equal "Oakland", Charity.where("name = '#{name}'").close_to(geo).first.address.city
    end
  end

  should "activate and deactivate" do
    charity = charities(:save_the_redwoods_leage)
    assert_equal :active, charity.aasm_current_state
    assert charity.deactivate!, "should deactivate"
    assert_equal :inactive, charity.aasm_current_state
    assert charity.activate!, "should activate again"
  end

  should "add a blocked merchant" do
    charity = charities(:alameda_food_bank)
    assert_difference "charity.blocked_merchants.count" do
      charity.blocked_merchants << merchants(:books_inc)
    end
  end

  should "not add an existing blocked merchant" do
    charity = charities(:alameda_food_bank)
    assert_difference "charity.blocked_merchants.count", 1 do
      2.times { charity.blocked_merchants << merchants(:books_inc) }
    end
  end

  should "delete a merchant from the blocked merchant list" do
    charity = charities(:save_the_redwoods_leage)
    charity.blocked_merchants << merchants(:books_inc)
    assert_difference "charity.blocked_merchants.count", -1 do
      charity.blocked_merchants.clear
    end
  end
end
