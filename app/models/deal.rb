class Deal < ActiveRecord::Base
  extend FriendlyId
  friendly_id :code

  belongs_to :charity
  belongs_to :merchant
  belongs_to :bundle

  has_many :certificates, :dependent => :destroy

  attr_accessible :amount, :amount_cents, :merchant, :charity, :bundle

  # TODO: remove, not used after the bundles era
  money :amount, :cents => :amount_cents

  acts_as_sellable

  before_validation :create_code

  validates :code, :presence => true, :uniqueness => true
  validate :merchant_exceeds_monthly_certificates

  CODE_LENGTH = 16

  def complete?
    charity && (merchant || bundle)
  end

  def merchant_names
    if bundle
      bundle.offers.map { |offer| offer.merchant.name }
    elsif merchant
      [ merchant.name ]
    end
  end

  def merchant_ids
    if bundle
      bundle.offers.map { |offer| offer.merchant.id }
    elsif merchant
      [ merchant.id ]
    end
  end

  def merchants
    if bundle
      bundle.offers.map { |offer| offer.merchant }
    elsif merchant
      [merchant]
    end
  end

  def total_value
    if bundle
      bundle.donation_value
    else
      merchant.offer.donation_value
    end
  end
  alias :price :total_value

  def tagline
    if bundle
      bundle.tagline
    else
      merchant.offer.tagline
    end
  end

  private

  def create_code
    self.code ||= rand(36 ** CODE_LENGTH).to_s(36)
  end

  def merchant_exceeds_monthly_certificates
    if merchant && !merchant.available_certificates?
      errors.add(:merchant, "exceeds monthly certificates")
    end
    if bundle
      bundle.offers.each do |offer|
        if !offer.merchant.available_certificates?
          errors.add(:bundle, "#{offer.merchant.name} exceeds monthly certificates")
        end
      end
    end
  end
end
