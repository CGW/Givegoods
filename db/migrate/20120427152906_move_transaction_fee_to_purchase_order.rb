class MoveTransactionFeeToPurchaseOrder < ActiveRecord::Migration
  def up
    remove_column :certificates, :transaction_costs_included
    add_column :orders, :transaction_costs_included, :boolean

    remove_column :transaction_fees, :certificate_id
    add_column :transaction_fees, :order_id, :integer
    add_index :transaction_fees, [:order_id]
  end

  def down
    remove_column :orders, :transaction_costs_included
    add_column :certificates, :transaction_costs_included, :boolean

    remove_column :transaction_fees, :order_id
    add_column :transaction_fees, :certificate_id, :integer
    add_index :transaction_fees, [:certificate_id]
  end
end
