class Tier < ActiveRecord::Base
  MIN_AMOUNT = 1
  MAX_AMOUNT = 10000

  attr_accessible :amount, :tagline

  belongs_to :campaign

  money :amount, :cents => :amount_cents

  validates :tagline, :length => { :maximum => 255 }

  validates :amount_cents, 
    numericality: { 
      integer_only: true,
      greater_than_or_equal_to: MIN_AMOUNT*100,
      less_than_or_equal_to: MAX_AMOUNT*100 
    }, 
    :uniqueness => { 
      :scope => :campaign_id 
    }

  validates_each :amount do |record, attr, value|
    record.errors.add(:amount, "Amount must be between #{Money.new(MIN_AMOUNT*100).format(:no_cents_if_whole => true)} and #{Money.new(MAX_AMOUNT*100).format(:no_cents_if_whole => true)}") if record.errors[:amount_cents].present?
  end
end
