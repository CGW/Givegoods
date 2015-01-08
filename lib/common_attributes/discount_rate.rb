module CommonAttributes
  module DiscountRate
    extend ActiveSupport::Concern

    DISCOUNT_RATES = [25, 50, 100]

    included do
      validates_inclusion_of :discount_rate, :in => DISCOUNT_RATES
    end
  end
end
