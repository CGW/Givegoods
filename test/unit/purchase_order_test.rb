require 'test_helper'

class MerchantSidekick::PurchaseOrderTest < ActiveSupport::TestCase
  should have_one(:transaction_fee)

  should "build transaction fee" do
    assert_difference "TransactionFee.count" do
      order = FactoryGirl.build(:purchase_order, :with_transaction_fee => "1")
      assert_equal true, order.with_transaction_fee?
      order.save!
      assert_equal "$2.30", order.transaction_fee.amount.format
    end
  end

  should "not build transaction fee" do
    assert_no_difference "TransactionFee.count" do
      order = FactoryGirl.build(:purchase_order, :with_transaction_fee => "0")
      assert_equal false, order.with_transaction_fee?
      order.save!
    end
  end
end
