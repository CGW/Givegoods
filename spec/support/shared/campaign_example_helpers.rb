module CampaignExampleHelpers
  def create_campaign_with_tier_taglines
    campaign = create(:active_charity).campaign
    campaign.tiers.each do |t| 
      t.tagline = "Helps us stay running for #{t.id} days"
      t.save!
    end

    campaign
  end
end
