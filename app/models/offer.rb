class Offer < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :charity

  has_many :bundlings, :dependent => :destroy
  has_many :bundles, :through => :bundlings

  attr_accessor :charity_selection, :charity_name
  attr_accessible :rules, :min_amount, :offer_cap_cents, :offer_cap, :status,
    :charity_selection, :charity_name, :charities_near, :charity_id, :discount_rate,
    :max_certificates, :tagline

  STATUSES           = %w(paused active)
  # Note that we're temporarily allowing a max certificate value of 2 for
  # testing purposes. This should be eliminated later. 
  # Norman, I removed this - CGW.
  MAX_CERTIFICATES   = [50, 75, 100, 250, 500, 750, 1000]
  MIN_OFFER_CAP      = 0
  MAX_OFFER_CAP      = 1000
  MAX_DONATION_VALUE = 1000

  validates_inclusion_of :status,           :in => STATUSES
  validates_inclusion_of :max_certificates, :in => MAX_CERTIFICATES

  include CommonAttributes::OfferCapCents
  include CommonAttributes::DiscountRate

  scope :active, where(:status => "active")
  scope :by_merchant_name, joins(:merchant).order('merchants.name ASC')

  before_validation :update_charity_selection

  def to_s
    "#{merchant.name} (#{discount_rate}% up to #{offer_cap.format(:no_cents_if_whole => true)})"
  end

  def charity_selection
    @charity_selection ? @charity_selection.to_sym : @charity_selection = begin
      if charity_id
        :one
      elsif self.lat && self.lng && self.charities_near
        :near
      else
        :all
      end
    end
  end

  def charity_name
    @charity_name ||= begin
      charity.name if self.charity
    end
  end

  def donation_value
    if any_cap?
      if offer_cap_cents >= 7500
        value = (offer_cap_cents * discount_rate) / 400
      else
        value = (offer_cap_cents * discount_rate) / 200
      end
      # Rounding down
      if value >= 1000
        # if $10 or larger, rounding down to closest multiple of $1
        value = (value / 100) * 100
      end
    else
      # if offer_cap is unlimitted return $100
      value = 10000 
    end
    Money.new(value, currency || Money.default_currency)
  end

  private

  def update_charity_selection
    case charity_selection
    when :all
      self.charity_id, self.lat, self.lng, self.charities_near = nil, nil, nil, nil
    when :one
      unless self.charity_name.blank?
        self.lat, self.lng, self.charities_near = nil, nil, nil
      else
        self.charity_id, self.lat, self.lng, self.charities_near = nil, nil, nil, nil
        errors.add(:charity_name, "not found")
      end
    when :near
      begin
        result = GiveGoods::Geocoder.new(self.charities_near)
        self.charity_id, self.lat, self.lng, self.charities_near  = nil, result.lat, result.lng, result.address || self.charities_near
      rescue GiveGoods::Geocoder::Error
        errors.add(:charities_near, "could not be understood as location")
      end
    end
  end
end
