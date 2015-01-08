class DropOfferValuesTables < ActiveRecord::Migration
  def up
    drop_table :offer_values
    drop_table :offer_values_offers
  end

  def down
    create_table "offer_values", :force => true do |t|
      t.integer  "donation_amount_cents", :default => 0,     :null => false
      t.integer  "credit_amount_cents",   :default => 0,     :null => false
      t.integer  "spending_amount_cents", :default => 0,     :null => false
      t.string   "currency",              :default => "USD", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "offer_values", ["donation_amount_cents"], :name => "index_offer_values_on_donation_amount_cents"

    create_table "offer_values_offers", :force => true do |t|
      t.integer "offer_id"
      t.integer "offer_value_id"
    end

    add_index "offer_values_offers", ["offer_id", "offer_value_id"], :name => "index_offer_values_offers_on_offer_id_and_offer_value_id"
  end
end
