class AddCharityIdToCertificates < ActiveRecord::Migration
  def change
    add_column :certificates, :charity_id, :integer
    add_index :certificates, :charity_id
    add_index :certificates, :merchant_id
    add_index :certificates, :customer_id
  end
end
