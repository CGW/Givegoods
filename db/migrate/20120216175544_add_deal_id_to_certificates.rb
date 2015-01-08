class AddDealIdToCertificates < ActiveRecord::Migration
  def change
    add_column :certificates, :deal_id, :integer
    add_index :certificates, :deal_id
  end
end
