class Users::CampaignsController < ApplicationController

  ssl_required :edit, :update
  before_filter :authenticate_user!, :only => [:edit, :update]
  before_filter :load_resources_or_redirect, :only => [:edit, :update]

  layout 'bootstrap/users'

  def update
    if @campaign.update_attributes(params[:campaign])
      flash[:success] = "Your donation page has been updated."
      redirect_to edit_user_campaign_path and return
    end

    render :edit
  end

  private

  def load_resources_or_redirect
    @charity = current_user.charity
    
    unless @charity
      redirect_to new_user_charity_path and return
    end

    @campaign = @charity.campaign
  end
end
