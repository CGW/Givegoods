class Donation < ActiveRecord::Base
  MIN_AMOUNT = 1
  MAX_AMOUNT = 10000

  attr_accessible :amount, :charity_id

  acts_as_sellable

  belongs_to :order, :class_name => 'MerchantSidekick::PurchaseOrder'
  belongs_to :charity
  belongs_to :campaign

  validates :order, :charity,
    :presence => true

  money :amount, :cents => :amount_cents
  alias price amount

  validates :amount_cents, 
    numericality: { 
      integer_only: true,
      greater_than_or_equal_to: MIN_AMOUNT*100,
      less_than_or_equal_to: MAX_AMOUNT*100 
    }

  validates_each :amount do |record, attr, value|
    record.errors.add(:amount, 
                      :invalid, 
                      :min => Money.new(MIN_AMOUNT*100).format(:no_cents_if_whole => true), 
                      :max => Money.new(MAX_AMOUNT*100).format(:no_cents_if_whole => true)
                     ) if record.errors[:amount_cents].present?
  end

  scope :successful, joins(:order).where('orders.status = ?', 'approved')

  def title
    "Donation to '#{charity.name}'" if charity
  end
end
