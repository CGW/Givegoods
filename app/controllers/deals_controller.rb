class DealsController < ApplicationController
  before_filter :load_merchant, :only => [:create]
  before_filter :load_charity, :only => [:create]
  before_filter :load_bundle, :only => [:create]
  before_filter :build_deal, :only => [:create]

  def create
    @deal.save!
    # TODO: use a respond_to block here
    cookies.permanent[:shopping_basket] = Basket.new(cookies[:shopping_basket]).add(@deal).to_json
  end

  def destroy
    if @deal = Deal.find_by_code(params[:id])
      @deal.destroy
      cookies.permanent[:shopping_basket] = Basket.new(cookies[:shopping_basket]).remove(@deal).to_json
    else
      # Empties the cookie because it has invalid deals
      cookies.permanent[:shopping_basket] = Basket.new.to_json
    end
  end

  private

  def load_merchant
    @merchant = Merchant.with_active_offer.find params[:merchant_id] if params[:merchant_id]
  end

  def load_charity
    @charity = Charity.find params[:charity_id]
  end

  def load_bundle
    @bundle = @charity.bundles.find params[:bundle_id] if params[:bundle_id]
  end

  def build_deal
    @deal = Deal.new :charity => @charity,
                     :merchant => @merchant,
                     :bundle => @bundle,
                     :amount_cents => params[:deal].try(:[], :amount_cents)
  end
end
