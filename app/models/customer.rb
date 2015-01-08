class Customer < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :anonymous_donation,
    :billing_address_attributes, :terms, :communicate_with_site

  has_many :certificates
  has_many :newsletter_subscriptions, :dependent => :destroy
  has_address :billing
  accepts_nested_attributes_for :billing_address
  acts_as_buyer

  attr_accessor :terms, :communicate_with_site

  # Also validated on ActiveMerchant::Billing::CreditCard
  validates :first_name, :last_name, :presence => true

  validates :email, :presence => true
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }, :if => Proc.new {|c| c.email.present?}

  validates :terms, :acceptance => true
  validates :anonymous_donation, :inclusion => {:in => [true, false]}

  after_create :create_customer_newsletter_subscriptions!

  def name
    result = []
    result << first_name
    result << last_name
    result.reject(&:blank?).join(" ")
  end

  def site_newsletter_subscriptions
    newsletter_subscriptions.where(:merchant_id => nil, :charity_id => nil)
  end

  def communicate_with_site?
    !!communicate_with_site.to_s.match(/^true|1/)
  end

  private

  def create_customer_newsletter_subscriptions!
    newsletter_subscriptions.create! if communicate_with_site?
  end
end
