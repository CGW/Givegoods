class Charity < ActiveRecord::Base
  extend FriendlyId
  include AASM
  include GiveGoods::Geocodable
  friendly_id :name, use: :slugged

  paginates_per 4*15

  belongs_to :user
  has_one :campaign, :dependent => :destroy

  has_many :offers, :dependent => :destroy
  has_many :certificates
  has_many :bundles, :dependent => :destroy

  has_and_belongs_to_many :blocked_merchants, :class_name => 'Merchant', :uniq => true

  has_many :donations
  has_many :purchase_orders, :through => :donations
  has_many :featurings, :dependent => :destroy
  has_many :featured_merchants, :through => :featurings, :source => :merchant, :order => "featurings.priority DESC"

  accepts_nested_attributes_for :featurings, :allow_destroy => true

  mount_uploader :picture, ImageUploader

  has_address
  accepts_nested_attributes_for :address

  # attr_accessible :status, :as => :admin
  acts_as_seller

  attr_accessor :communicate_with_merchant, :communicate_with_charity,
    :communicate_with_site, :with_additional_donation_amount

  validates :name, :ein, :website_url, :presence => true
  validates :ein, :uniqueness => true

  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }, :if => Proc.new {|c| c.email.present?}
  validates :email, :description, :presence => true, :if => :active?

  normalize_attribute :name, :ein, :email, :description, :website_url
  normalize_attribute :website_url, :with => [:strip, :blank, :uri_encode] do |value|
    value = "http://#{value}" if value.present? && !value.to_s.match(/^http(s)?:\/\//)
    value
  end

  #--- state machine
  aasm_initial_state :inactive
  aasm :column => "status" do
    state :inactive
    state :active

    event :activate, :after => :enter_active do
      transitions :from => :inactive, :to => :active
    end

    event :deactivate do
      transitions :from => :active, :to => :inactive
    end
  end

  before_destroy :stop_if_certificates_present

  # TODO improve scope once we have states for charities
  scope :active, where("charities.status = ?", 'active')
  scope :inactive, where("charities.status = ?", 'inactive')
  scope :with_picture,    :conditions => "charities.picture IS NOT NULL"
  scope :without_picture, :conditions => "charities.picture IS NULL"

  def self.for_picture_import
    scoped.without_picture.where("temp_image_url IS NOT NULL OR temp_image_url2 IS NOT NULL")
  end

  def best_image_url
    [temp_image_url, temp_image_url2].detect do |x|
      x =~ /\.(jpg|gif|png)\z/
    end
  end

  def self.by_name(name)
    where("to_tsvector('english', name) @@ plainto_tsquery(?)", name)
  end

  def city_and_state
    return unless address
    [address.city, address.province_code].reject(&:blank?).join(", ")
  end

  # Scope to retrieve all active merchants that run a campaign for this charity.
  #
  # E.g.
  #
  #   @charity.merchants
  #
  def merchants
    # Note: this query uses the radius instead the boxed version of the search.
    # We should add this
    radius = 50000
    query =  %Q{
      (merchants.lat IS NOT NULL AND merchants.lng IS NOT NULL) AND
      offers.merchant_id = merchants.id AND (
        (offers.charity_id IS NULL
          AND offers.lat IS NULL
          AND offers.lng IS NULL
        )
        OR
        (offers.charity_id = #{quote_value(id)}
          AND offers.lat IS NULL
          AND offers.lng IS NULL
        )
        OR
        (offers.charity_id IS NULL
          AND offers.lat IS NOT NULL
          AND offers.lng IS NOT NULL
          AND earth_box(ll_to_earth(#{self.lat || 0}, #{self.lng || 0}), #{radius})
            @>
          ll_to_earth(#{Offer.quoted_table_name}.lat, #{Offer.quoted_table_name}.lng
          )
        )
      )
    }
    Merchant.
      joins(:offer).
      without_merchants(blocked_merchants).
      preferring(address.city, address.province_code).
      where(query).scoped
  end

  def total_donation_amount
    total_certificate_donation_cents = self.certificates.donatable.sum("amount_cents")
    total_additional_donation_cents = Charity.joins(:donations).sum("donations.amount_cents").to_i
    Money.new(total_certificate_donation_cents + total_additional_donation_cents)
  end

  def total_donation_count
    self.certificates.donatable.count
  end

  private

  def enter_active
    EmailService.activated_charity(self)
  end

  def stop_if_certificates_present
    # Merchants with certificates can't be deleted
    if certificates.count > 0
      errors.add :base, "Charity has certificates, can't be deleted!"
      false
    else
      true
    end
  end
end
