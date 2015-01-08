class AddDealTotalCentsToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates,  :deal_total_cents, :integer
  end
end
