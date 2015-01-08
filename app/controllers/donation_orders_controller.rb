class DonationOrdersController < ApplicationController
  before_filter :find_charity, :only => [:create]
  before_filter :find_campaign, :only => [:create]

  ssl_required :create

  layout 'bootstrap/campaigns'

  def create
    @title = @campaign.name
    @donation_order = DonationOrder.new(params[:donation_order])

    @donation_order.charity = @charity
    @donation_order.campaign = @campaign
    @donation_order.request_remote_ip = request.remote_ip

    if @donation_order.save
      OrderMailer.paid(@donation_order.order).deliver
      redirect_to order_path(@donation_order.order) and return
    end

    render 'new'
  end

  protected 

  def find_charity
    @charity = Charity.active.find(params[:charity_id])
  end

  def find_campaign
    @campaign = Campaign.for_charity(@charity).find_by_slug!(params[:campaign_id])
    @campaign_stat = CampaignStat.for(@campaign)
  end
end
