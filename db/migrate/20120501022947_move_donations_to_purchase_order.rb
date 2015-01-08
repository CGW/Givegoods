class MoveDonationsToPurchaseOrder < ActiveRecord::Migration
  def up
    remove_column :donations, :certificate_id

    add_column :donations, :charity_id, :integer
    add_column :donations, :order_id, :integer

    add_index :donations, [:order_id]
    add_index :donations, [:order_id, :charity_id]
  end

  def down
    remove_column :donations, :charity_id
    remove_column :donations, :order_id
    add_column :donations, :certificate_id, :integer
    add_index :donations, [:certificate_id]
  end
end
