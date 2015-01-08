module CommonAttributes
  module AmountCents
    extend ActiveSupport::Concern

    MIN_AMOUNT = 1
    MAX_AMOUNT = 500

    included do
      money :amount, :cents => :amount_cents

      validates :amount_cents, 
        numericality: { 
        integer_only: true,
        greater_than_or_equal_to: MIN_AMOUNT*100,
        less_than_or_equal_to: MAX_AMOUNT*100 
      }

      validates_each :amount do |record, attr, value|
        record.errors.add(:amount, "must be between $#{MIN_AMOUNT} and $#{MAX_AMOUNT}") if record.errors[:amount_cents].present?
      end
    end
  end
end
