class CreateACampaignForEachCharity < ActiveRecord::Migration
  def up
    Charity.all.each do |charity|
      return if charity.campaign.present?
      charity.create_campaign!(
        :tagline          => "Make a contribution to #{charity.name}",
        :slug             => "donate",
        :tiers_attributes => [
          { :amount => 25 },
          { :amount => 50 },
          { :amount => 100 },
          { :amount => 250 },
        ]
      )
    end
  end

  def down
  end
end
