module MerchantSidekick
  class PurchaseOrder < Order
    extend FriendlyId
    friendly_id :number
    attr_accessor :with_transaction_fee, :with_additional_donation_amount

    has_one :transaction_fee, :dependent => :destroy, :foreign_key => "order_id"
    before_validation :build_transaction_fee!, :on => :create

    has_many :donations, :dependent => :destroy, :foreign_key => "order_id"
    has_many :donation_charities, :through => :donations, :source => :charity

    def self.approved
      where(:status => "approved")
    end

    def certificates
      deals.inject([]) { |m, o| m.concat(o.certificates.to_a); m }
    end

    def deal_certificates(deal)
      self.certificates.select{|c| c.deal == deal}
    end

    def charity_certificates(charity_id)
      certificates.select{|c| c.charity_id == charity_id}
    end

    def charity_donations(charity_id)
      donations.select{ |d| d.charity_id == charity_id}
    end

    def charity_deals(charity_id)
      deals.select{|d| d.charity_id == charity_id}
    end

    def charities
      (deals.map(&:charity) + donations.map(&:charity)).uniq
    end

    def deals
      line_items.select{|li| li.sellable.is_a?(Deal)}.map(&:sellable)
    end

    def with_transaction_fee?
      !!with_transaction_fee.to_s.match(/^true|1/)
    end

    def build_transaction_fee!
      build_transaction_fee :amount => TransactionFee.calculate(total) if with_transaction_fee?
    end

    def with_additional_donation_amount
      donations && donations.any? && donations.map{|d| d.amount_cents.to_i}.reduce(:+) != 0
    end

    def donations_total_amount
      donations.map(&:amount).reduce(:+) || ::Money.new(0, "USD")
    end

    def deals_total_amount
      line_items.where('sellable_type = ?', 'Deal').map(&:amount).reduce(:+) || ::Money.new(0, "USD")
    end

    def charity_donation_total(charity)
      (charity_deals(charity.id).map(&:total_value).reduce(:+) || ::Money.new(0, "USD")) +
      (charity_donations(charity.id).map(&:amount).reduce(:+) || ::Money.new(0, "USD"))
    end
  end
end
