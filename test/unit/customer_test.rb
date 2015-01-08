require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  should "purchase differents sellables" do
    deal = FactoryGirl.build(:deal)
    donation = FactoryGirl.build(:donation)
    transaction_fee = FactoryGirl.build(:transaction_fee)

    items = [deal, donation, transaction_fee]

    customer = FactoryGirl.build(:customer)
    order = customer.purchase items

    assert_equal items.size, order.line_items.size
    order_items = order.line_items.map(&:sellable)
    items.each do |item|
      assert order_items.include?(item)
    end
  end

  should "build site newsletter subscription" do
    assert_difference "NewsletterSubscription.count" do
      certificate = FactoryGirl.create(:customer, {:communicate_with_site  => "1"})
    end
  end
end
