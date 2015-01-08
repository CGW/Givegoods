require 'test_helper'

class TransactionFeeTest < ActiveSupport::TestCase
  setup do
    @purchase_order = FactoryGirl.create(:purchase_order)
  end

  should belong_to(:order)

  should "create" do
    fee = TransactionFee.create! :order => @purchase_order, :amount => "1.60"
    assert_equal "$1.60", fee.amount.format
    assert_equal @purchase_order.id, fee.order_id
  end

  should "be sellable" do
    assert TransactionFee.new.sellable?
  end

  should "have title" do
    fee = TransactionFee.create! :order => @purchase_order, :amount => "1.60"
    assert_equal "Transaction fee for order:#{@purchase_order.id}", fee.title
  end
end
