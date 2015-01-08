class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer  "certificate_id"
      t.integer  "amount_cents"
      t.string   "currency", :default => "USD", :null => false
      t.timestamps
    end
    add_index :donations, :certificate_id
  end
end
