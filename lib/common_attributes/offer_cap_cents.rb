module CommonAttributes
  module OfferCapCents
    extend ActiveSupport::Concern

    MIN_OFFER_CAP = 0
    MAX_OFFER_CAP = 1000

    included do
      money :offer_cap, :cents => :offer_cap_cents

      validates :offer_cap_cents, 
        numericality: { 
        integer_only: true,
        greater_than_or_equal_to: MIN_OFFER_CAP*100,
        less_than_or_equal_to: MAX_OFFER_CAP*100 
      }

      validates_each :offer_cap do |record, attr, value|
        record.errors.add(:offer_cap, "must be between $#{MIN_OFFER_CAP} and $#{MAX_OFFER_CAP}") if record.errors[:offer_cap_cents].present?
      end
    end

    def any_cap?
      offer_cap_cents && offer_cap_cents > 0
    end

    def offer_value
      if any_cap?
        value = (offer_cap_cents * discount_rate) / 100
      end

      Money.new(value || 0, currency || Money.default_currency)
    end
  end
end
