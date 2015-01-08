class TransactionFee < ActiveRecord::Base
  cattr_accessor :percent
  @@percent = 2.9
  @@fixed   = 0.30

  belongs_to :order, :class_name => "MerchantSidekick::PurchaseOrder"

  money :amount, :cents => :amount_cents
  alias price amount

  validates :order_id, :amount, :presence => true

  acts_as_sellable

  class << self
    def calculate(amount)
      # amount.to_money * (percent / 100.0) + @fixed.to_money
      # Money.new(160, "USD")
      Money.new(2000 * (10 / 100.0) + 30, "USD")
    end
  end

  def title
    "Transaction fee for order:#{order_id}"
  end
end
