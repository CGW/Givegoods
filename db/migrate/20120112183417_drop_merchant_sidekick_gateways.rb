class DropMerchantSidekickGateways < ActiveRecord::Migration
  def up
    drop_table :gateways
  end

  def down
    create_table :gateways do |t|
      t.string   "name",            :null => false
      t.string   "mode"
      t.string   "type"
      t.string   "login_id"
      t.string   "transaction_key"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "gateways", ["name"], :name => "index_gateways_on_name"
    add_index "gateways", ["type"], :name => "index_gateways_on_type"
  end
end
