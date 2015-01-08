class MerchantsController < ApplicationController
  before_filter :find_charity, :only => [:index, :search, :show]
  before_filter :find_merchants, :only => [:index, :search, :show]

  def index
    @merchants = @merchants.order('(offers.offer_cap_cents*offers.discount_rate) DESC')

    if @charity
      @title = "#{@charity.name} :: #{t("site.title")}"
    else
      @title = "Rewards :: #{t("site.title")}"
    end
  end

  def search
    @merchants = @merchants.with_sufficient_budget
    @merchants = @merchants.close_to(GiveGoods::Geocoder.new(params[:place])) if params[:place].present?
    @merchants = @merchants.by_name(params[:name]) if params[:name].present?
    @merchants = @merchants.order("merchants.name ASC")
  rescue GiveGoods::Geocoder::Error
    @merchants = []
  ensure 
    render "index"
  end

  def show
    redirect_to merchants_path, :status => 301 unless @charity
    @merchant = Merchant.active_or_owned_by(current_user).find(params[:id])
  end

  protected

  def find_charity
    if params[:charity_id]
      @charity = Charity.active.find(params[:charity_id])
      @bundles = @charity.bundles.includes(:bundlings => { :offer => [:merchant] }).order("donation_value_cents").active
    end
  end

  def find_merchants
    if @charity
      @merchants = @charity.merchants.with_active_offer.includes(:offer)
    else
      @merchants = Merchant.with_active_offer.includes(:offer)
    end

    @merchants = @merchants.includes(:address)
  end
end
