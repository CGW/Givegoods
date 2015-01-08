class Certificate < ActiveRecord::Base
  include AASM
  extend FriendlyId
  friendly_id :code

  CODE_LENGTH = 8

  belongs_to :merchant
  belongs_to :customer
  belongs_to :charity
  belongs_to :deal

  before_validation :create_code, :on => :create

  validates :merchant_id, :charity_id, :presence => true
  validates :customer, :presence => true, :associated => true
  validates :code, :presence => true, :uniqueness => true

  after_create :create_customer_newsletter_subscriptions!

  include CommonAttributes::OfferCapCents
  include CommonAttributes::AmountCents
  include CommonAttributes::DiscountRate

  attr_accessor :communicate_with_merchant, :communicate_with_charity

  #--- state machine
  aasm_initial_state :unredeemed
  aasm :column => "status" do
    state :unredeemed
    state :redeemed
    state :canceled

    event :redeem do
      transitions :from => :unredeemed, :to => :redeemed
    end

    event :unredeem do
      transitions :from => :redeemed, :to => :unredeemed
    end

    event :cancel do
      transitions :from => [:redeemed, :unredeemed], :to => :canceled
    end
  end

  scope :unredeemed, where(:status => "unredeemed")
  scope :redeemed, where(:status => "redeemed")
  scope :canceled, where(:status => "canceled")
  scope :donatable, where("status IN (?)", ["redeemed", "unredeemed"])
  scope :current_month, where("created_at >= ? AND created_at <= ?", Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)

  def title
    "#{amount.format} gift certificate redeemable at #{merchant.name}"
  end

  def communicate_with_charity?
    !!communicate_with_charity.to_s.match(/^true|1/)
  end

  def communicate_with_merchant?
    !!communicate_with_merchant.to_s.match(/^true|1/)
  end

  private

  def create_code
    self.code ||= rand(36 ** CODE_LENGTH).to_s(36).upcase
  end

  def create_customer_newsletter_subscriptions!
    customer.newsletter_subscriptions.create! :merchant => merchant if customer && communicate_with_merchant?
    customer.newsletter_subscriptions.create! :charity => charity if customer && communicate_with_charity?
  end
end
