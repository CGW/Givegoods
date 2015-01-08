class AddCampaignBundleTaglineToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :campaign_bundle_tagline, :string
  end
end
