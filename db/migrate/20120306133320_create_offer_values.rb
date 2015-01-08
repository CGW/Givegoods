class CreateOfferValues < ActiveRecord::Migration
  def change
    create_table :offer_values do |t|
      t.integer :donation_amount_cents, :default => 0, :null => false
      t.integer :credit_amount_cents, :default => 0, :null => false
      t.integer :spending_amount_cents, :default => 0, :null => false
      t.string :currency, :default => "USD", :null => false
      t.timestamps
    end
    add_index :offer_values, :donation_amount_cents
  end
end
