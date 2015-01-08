class CreateTransactionFees < ActiveRecord::Migration
  def change
    create_table :transaction_fees do |t|
      t.column :certificate_id, :integer
      t.column :amount_cents, :integer
      t.column :currency, :string, :null => false, :default => "USD"
      t.timestamps
    end
    add_index :transaction_fees, :certificate_id
  end
end
