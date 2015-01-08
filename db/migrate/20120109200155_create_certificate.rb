class CreateCertificate < ActiveRecord::Migration
  def change
    create_table(:certificates) do |t|
      t.integer :customer_id
      t.integer :merchant_id
      t.string  :code
      t.integer :amount
      t.boolean :transaction_costs_included
      t.string  :status, :default => 'unredeemed'
      t.timestamps
    end
  end
end
