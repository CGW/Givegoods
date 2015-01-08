class OrdersController < ApplicationController
  before_filter :load_cart, :only => [:new, :create]
  before_filter :load_charities_deals, :only => [:new, :create]
  before_filter :build_customer, :only => [:new, :create]
  before_filter :build_certificates, :only => [:new, :create]
  before_filter :build_credit_card, :only => [:new, :create]
  before_filter :build_donations, :only => [:new, :create]
  before_filter :build_order, :only => [:new, :create]
  
  before_filter :load_order, :only => [:show]

  ssl_required :new, :show, :create

  def new
  end

  def show
    @certificates = @order.certificates
    @charities = @order.charities
  end

  def create
    if valid?
      @payment = @order.pay @credit_card, :ip => request.remote_ip
      if @payment.success?
        @certificates.each{|c| c.save!}
        cookies.delete :shopping_basket
        OrderMailer.paid(@order).deliver
        redirect_to order_path(@order) and return
      end
    end
    render "new"
  end

  protected

  def ssl_required?
    ssl_supported?
  end

  def load_cart
    if !cookies[:shopping_basket]
      redirect_to merchants_path, notice: 'Heads up: it looks like your cart is empty - please add some rewards before checking out.'
    end
    @basket = Basket.new(cookies[:shopping_basket])
  end

  def load_order
    @order = MerchantSidekick::PurchaseOrder.find params[:id]
  end

  def load_charities_deals
    @charities = @basket.charities

    @deals = []
    @order_items = {}
    @charities.each do |charity|
      deals = @basket.deals_for(charity)
      @deals << deals
      @order_items[charity.id] = {
        :deals => deals,
        :charity => charity,
        :donations => [],
        :transaction_fee => nil
      }
    end
    @deals.flatten!.uniq!
  end

  def build_customer
    @customer = Customer.new params[:customer]
    @customer.build_billing_address unless @customer.billing_address
    @customer.billing_address.country_code = "US" unless @customer.billing_address.country_code
    @customer
  end

  def build_certificates
    @certificates = []
    @certificate_group_opts = Certificate.new params[:certificate]
    @charities.each do |charity|
      @order_items[charity.id][:certificates] = {}

      @order_items[charity.id][:deals].each do |deal|
        @order_items[charity.id][:certificates][deal.id] = []
        if deal.bundle
          deal.bundle.offers.each do |offer|
            certificate = Certificate.new({
              :deal                      => deal,
              :merchant                  => offer.merchant,
              :charity                   => deal.bundle.charity,
              :customer                  => @customer,
              :amount                    => offer.donation_value,
              :communicate_with_charity  => true,
              :communicate_with_merchant => false,
              :offer_cap_cents           => offer.offer_cap_cents,
              :donation_value_cents      => offer.donation_value.cents,
              :discount_rate             => offer.discount_rate,
              :rules                     => offer.rules,
              :tagline                   => offer.tagline,
              :deal_total_cents          => deal.total_value.cents
            }.merge((params[:certificate] || {}).symbolize_keys), :as => :admin)

            @certificates << certificate
            @order_items[charity.id][:certificates][deal.id] << certificate
          end
        else
          certificate = Certificate.new({
            :deal                      => deal,
            :merchant                  => deal.merchant,
            :charity                   => deal.charity,
            :customer                  => @customer,
            :amount                    => deal.total_value,
            :communicate_with_charity  => true,
            :communicate_with_merchant => false,
            :offer_cap_cents           => deal.merchant.offer.offer_cap_cents,
            :donation_value_cents      => deal.merchant.offer.donation_value.cents,
            :discount_rate             => deal.merchant.offer.discount_rate,
            :rules                     => deal.merchant.offer.rules,
            :tagline                   => deal.merchant.offer.tagline,
            :deal_total_cents          => deal.total_value.cents
          }.merge((params[:certificate] || {}).symbolize_keys), :as => :admin)

          @certificates << certificate
          @order_items[charity.id][:certificates][deal.id] << certificate
        end
      end
    end
  end

  def build_credit_card
    @credit_card = ActiveMerchant::Billing::CreditCard.new(
      (params[:credit_card] || {}).symbolize_keys.merge(
        :first_name => @customer.first_name,
        :last_name  => @customer.last_name))
  end

  def build_order
    donations = @donations.reject{|d| d.amount_cents <= 0}
    sellable_items = [@deals, donations].flatten

    if sellable_items.any?
      items_total = sellable_items.map(&:price).reduce(:+)

      if transaction_fee_costs_accepted?
        @transaction_fee = TransactionFee.new(:amount_cents => items_total.cents)
        sellable_items << @transaction_fee
      end

      @order = @customer.purchase(sellable_items, :from => @charity)
      @order.transaction_fee = @transaction_fee
      donations.each {|d| d.order = @order}
    end
  end

  def build_donations
    @donations = []

    if params[:order] && params[:order][:donations]
      params[:order][:donations].each do |key, donation|
        @donations << Donation.new(
          :charity_id => donation[:charity_id],
          :amount => donation[:amount])
      end
    else
      @charities.each_with_index do |charity, i|
        @donations << Donation.new(
          :charity_id => charity.id,
          :amount => 0.0)
      end
    end
  end

  def valid?
    cc = @credit_card.valid?
    cu = @customer.valid?
    ct = @certificates.reject{|c| c.valid?}.empty?
    po = @order.valid?
    cc && cu && ct && po
  end

  def transaction_fee_costs_accepted?
    params[:order] && !!params[:order][:with_transaction_fee].to_s.match(/^true|1/)
  end
end
