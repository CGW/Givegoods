class AddCampaignIdToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :campaign_id, :integer
    add_index :donations, :campaign_id
  end
end
