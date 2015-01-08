
class CampaignsController < ApplicationController
  before_filter :load_charity, only: [:show]

  ssl_required :show

  layout 'bootstrap/campaigns'

  def show 
    @donation_order = DonationOrder.new
    @campaign = Campaign.for_charity(@charity).with_tiers.find_by_slug!(params[:id])
    @campaign_stat = CampaignStat.for(@campaign)
    @title = @campaign.name
  end

  protected

  def load_charity
    @charity = Charity.active.find(params[:charity_id])
  end
end
