class Merchant < ActiveRecord::Base
  extend FriendlyId
  include AASM
  include GiveGoods::Geocodable

  friendly_id :name, use: :slugged

  paginates_per 4*15

  mount_uploader :picture, ImageUploader

  attr_accessor :terms_of_service
  attr_accessible :name, :description, :website_url, :picture, :terms_of_service,
                  :address_attributes, :remote_picture_url, :picture_cache, :remove_picture,
                  :offer_attributes
  attr_accessible :status, :as => :admin
  attr_protected :name, :as => :updating_merchant

  belongs_to :user

  has_one :offer, :dependent => :destroy

  has_many :deals, :dependent => :destroy
  has_many :certificates, :dependent => :nullify
  has_many :featurings, :dependent => :destroy
  has_many :featured_in_charities, :through => :featurings, :source => :charity

  has_and_belongs_to_many :blocked_merchants, :class_name => 'Charity', :uniq => true

  has_address

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :offer

  delegate :email, :to => :user

  #--- state machine
  aasm_initial_state :unconfirmed
  aasm :column => "status" do
    state :unconfirmed
    state :pending, :enter => :enter_pending
    state :active, :enter => :enter_active
    state :suspended

    event :register do
      transitions :from => :unconfirmed, :to => :pending, :guard => :user_email_and_website_domains_do_not_match?
      transitions :from => :unconfirmed, :to => :active, :guard => :user_email_and_website_domains_do_match?
    end

    event :activate do
      transitions :from => :pending, :to => :active
    end

    event :suspend do
      transitions :from => [:active, :pending], :to => :suspended
    end

    event :unsuspend do
      transitions :from => :suspended, :to => :active, :guard => Proc.new {|record| !!record.activated_at}
      transitions :from => :suspended, :to => :pending, :guard => Proc.new {|record| !!record.registered_at}
      transitions :from => :suspended, :to => :unconfirmed
    end
  end

  validates :name, :presence => true, :uniqueness => true
  validates :website_url, :presence => true
  validates :terms_of_service, :acceptance => true

  before_destroy :stop_if_certificates_present
  after_destroy :destroy_user

  scope :unconfirmed, where(:status => 'unconfirmed')
  scope :pending, where(:status => 'pending')
  scope :waiting, where("status IN (?)", ["unconfirmed", "pending"])
  scope :active, where(:status => 'active')
  scope :suspended, where(:status => 'suspended')
  scope :recent, lambda {|n = nil| n.nil? ? order("created_at DESC").limit(10) : order("created_at DESC").limit(n)}

  def self.active_or_owned_by(user)
    where "status = 'active' or (user_id IS NOT NULL AND user_id = ?)", user.try(:id)
  end

  def self.with_active_offer
    joins(:offer).where("merchants.status = 'active' AND offers.status = 'active'")
  end

  # Merchants that have not reached the monthly limit for issued certificates
  def self.with_sufficient_budget
    zeroer = "(COALESCE(%s, 0))"
    max_certs = "(SELECT offers.max_certificates FROM offers WHERE offers.merchant_id = merchants.id AND offers.status = 'active')"
    max_certs = zeroer % max_certs
    sum_ac = "(SELECT COUNT(*) FROM certificates WHERE certificates.merchant_id = merchants.id AND (certificates.status = 'redeemed' OR certificates.status = 'unredeemed') AND (certificates.created_at >= ? AND certificates.created_at <= ?))"
    sum_ac = send :sanitize_sql, [sum_ac, Time.zone.now.beginning_of_month, Time.zone.now.end_of_month]
    sum_ac = zeroer % sum_ac
    except(:select).select("#{quoted_table_name}.*, #{max_certs} AS max_certs, #{sum_ac} AS sum_ac").where("#{max_certs} > #{sum_ac}")
  end

  def self.by_name(name)
    where("to_tsvector('english', name) @@ plainto_tsquery(?)", name)
  end

  def self.without_merchants(merchants)
    if merchants.any?
      where("merchant_id not in (?)", merchants)
    else
      scoped
    end
  end

  def city_and_state
    result = []
    result << address.city if address && address.city
    result << address.province_code if address && address.province_code
    result.reject(&:blank?).join(", ")
  end

  # Scope to retrieve all charities for which merchant runs a campaign
  def charities(geo = nil)
    geo ||= address
    case charity_selection
    when :all
      scoped = Charity.preferring(geo.city, geo.province_code)
      geocoded? ? scoped.sorted_by_distance(lat, lng) : scoped
    when :one
      Charity.where(:id => offer.charity_id)
    when :near
      Charity.preferring(address.city, address.province_code).near(offer)
    else
      Charity.joins(:offers).joins("INNER JOIN merchants ON merchants.id = offers.merchant_id").scoped
    end
  end

  def charity_selection
    offer.try(:charity_selection)
  end

  def geocoded?
    self.lat && self.lng
  end

  def month_to_date_certificates_count
    certificates.donatable.current_month.count
  end

  def available_certificates?
    offer && month_to_date_certificates_count < offer.max_certificates
  end

  def website_host
    URI.parse(website_url).host || website_url
  rescue URI::InvalidURIError
    website_url
  end

  def total_donation_amount
    Money.new(self.certificates.donatable.sum(:amount_cents))
  end

  def total_donation_count
    self.certificates.donatable.count
  end

  def offer_to_s
    # this methods is used for autocompletion in admin
    try(:offer).to_s
  end

  private

  def user_email_and_website_domains_do_match?
    !!(website_domain && user_email_domain && website_domain == user_email_domain)
  end

  def user_email_and_website_domains_do_not_match?
    !user_email_and_website_domains_do_match?
  end

  def website_domain
    if host = URI.parse(website_url).host
      host.gsub(/^www\./, '')
    end
  rescue URI::InvalidURIError
    nil
  end

  def user_email_domain
    $1 if user && user.email.match(/@(.*)$/)
  end

  def enter_active
    self.registered_at ||= Time.zone.now
    self.activated_at ||= Time.zone.now
    MerchantMailer.active(self).deliver if self.user
    AdminMailer.new_merchant(self).deliver if self.user
  end

  def enter_pending
    self.registered_at ||= Time.zone.now
    MerchantMailer.pending(self).deliver if self.user
    AdminMailer.new_merchant(self).deliver if self.user
  end

  def destroy_user
    self.user.destroy if self.user
  end

  def stop_if_certificates_present
    # Merchants with certificats can't be deleted
    if certificates.count > 0
      errors.add :base, "Merchant has certificates, can't be deleted!"
      false
    else
      true
    end
  end
end
