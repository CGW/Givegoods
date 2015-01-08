class CharitiesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :search, :show, :landing]
  before_filter :find_merchant
  before_filter :find_charities, :only => [:index, :search, :show]

  def index
    if @merchant
      @title = "#{@merchant.name} :: #{t("site.title")}"
    else
      @title = "Charities :: #{t("site.title")}"
    end
    # This is a hack to avoid paging through the entire database when the
    # merchant has selected to support "all" charities. Once we resolve how to
    # handle pagination this should be replaced with something more reasonable.
    if @merchant and @merchant.charity_selection == :all
      city           = @merchant.address.city
      state          = @merchant.address.province_code
      @charity_count = Charity.active.preferring(city, state).near(@merchant).count
      @charities     = Charity.active.preferring(city, state).near(@merchant)
      # I needed to comment the next line because it interferes with basket JS
      # fresh_when(:last_modified => @merchant.updated_at, :public => true)
    end
  end

  def search
    @charities = @charities.close_to(GiveGoods::Geocoder.new(params[:place])) if params[:place].present?
    @charities = @charities.by_name(params[:name]) unless params[:name].blank?
    @charities = @charities.order("charities.name ASC")
  rescue GiveGoods::Geocoder::Error
    @charities = []
  ensure
    render "index"
  end

  def show
    redirect_to charities_path, :status => 301 unless @merchant
    @charity = Charity.active.find(params[:id])
    @title = "%s :: %s" % [@charity.name, t("site.title")]
  end

  def landing
    @charity = Charity.active.includes(:campaign).find(params[:id])
    @title = "#{@charity.name} :: #{t("site.title")}"
  end

  protected

  def find_merchant
    @merchant = Merchant.with_active_offer.find(params[:merchant_id]) if params[:merchant_id]
  end

  def find_charities
    @charities = if @merchant
      @merchant.charities(@geo).active
    else
      Charity.active
    end
    @charities = @charities.includes(:address)
    @charities = @charities.order("charities.name DESC") unless action_name == "search"
  end

end
