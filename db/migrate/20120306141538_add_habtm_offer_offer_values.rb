class AddHabtmOfferOfferValues < ActiveRecord::Migration
  def up
    create_table :offer_values_offers do |t|
      t.integer :offer_id
      t.integer :offer_value_id
    end
    add_index :offer_values_offers, [:offer_id, :offer_value_id]
  end

  def down
    drop_table :offer_values_offers
  end
end
