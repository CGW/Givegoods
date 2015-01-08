class DonationOrder
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveRecord::AttributeAssignment

  attr_reader :order, :payment
  attr_accessor :donation, :customer, :credit_card, :charity, :campaign, :request_remote_ip
  attr_accessible :donation, :customer, :credit_card

  validates :donation, :customer, :credit_card, :charity, :campaign, :request_remote_ip,
    :presence => true

  validates_each :donation, :customer do |record, attr, value|
    if value.present? and !value.valid?
      value.errors.each do |value_attr, message|
         record.errors.add "#{attr}.#{value_attr.to_sym}", message
      end
    end
  end

  # ActiveMerchant::Billing::CreditCard.errors returns a hash of messages:
  #   {:attr => [msg]}
  validates_each :credit_card do |record, attr, value|
    if value.present? and !value.valid?
      value.errors.each do |value_attr, messages|
        messages.each do |message|
          record.errors.add "#{attr}.#{value_attr.to_sym}", message
        end
      end
    end
  end

  def initialize(attributes = {})
    attributes.each do |attr, value|
      self.send(:"#{attr}=", value)
    end

    @donation = Donation.new                                    if @donation.blank?
    @customer = Customer.new(:billing_address_attributes => {}) if @customer.blank?
    @credit_card = ActiveMerchant::Billing::CreditCard.new      if @credit_card.blank?
  end

  def save 
    ActiveRecord::Base.transaction do
      @donation.charity = @charity
      @donation.campaign = @campaign

      @credit_card.first_name = @customer.first_name
      @credit_card.last_name = @customer.last_name

      @order = @customer.purchase([donation], :from => @charity)
      @donation.order = @order
      
      # Be sure we don't save anything
      unless self.valid?
        raise ActiveRecord::Rollback
      end
    end

    return false unless self.valid?

    @payment = @order.pay(@credit_card, :ip => @request_remote_ip)
    return false unless valid_payment?

    # yay!
    return true
  end

  def persisted? 
    false
  end

  def donation=(record_or_hash)
    @donation = case record_or_hash
                when Donation
                  record_or_hash
                when Hash
                  Donation.new(record_or_hash)
                end
  end

  def customer=(record_or_hash)
    @customer = case record_or_hash
                when Customer
                  record_or_hash
                when Hash
                  Customer.new(record_or_hash)
                end
  end

  def credit_card=(record_or_hash)
    @credit_card = case record_or_hash
                   when ActiveMerchant::Billing::CreditCard
                     record_or_hash
                   when Hash
                     ActiveMerchant::Billing::CreditCard.new(record_or_hash)
                   end
  end

  private 

  def valid_payment?
    unless @payment.success?
      errors.add :payment, payment.message
      return false
    end

    return true
  end

end
