require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "should validate city attribute" do
    @address = MerchantSidekick::Addressable::Address.new
    assert_equal false, @address.valid?
    assert @address.errors[:city]
  end

  test "should use address_line_1 and address_line_2" do
    @address = MerchantSidekick::Addressable::Address.new :address_line_1 => "112 2nd St.", :address_line_2 => "Dpt. 2"
    assert_equal "112 2nd St.", @address.address_line_1
    assert_equal "Dpt. 2", @address.address_line_2
    assert_equal "112 2nd St.\nDpt. 2", @address.street
  end

  test "should validate country_code exists" do
    address = MerchantSidekick::Addressable::Address.new country_code: "XX"
    assert_error_on(address, :country_code)
  end

  test "should have a country" do
    address = MerchantSidekick::Addressable::Address.new country_code: "CA"
    assert_equal "Canada", address.country.name
  end

  test "should validate province_code exists" do
    address = MerchantSidekick::Addressable::Address.new province_code: "XX"
    assert_error_on(address, :province_code)
  end

  test "should have a province" do
    address = MerchantSidekick::Addressable::Address.new province_code: "OR"
    assert_equal "Oregon", address.province.name
  end
end
