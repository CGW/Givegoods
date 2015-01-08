class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer :charity_id
      t.integer :merchant_id
      t.string :code

      t.timestamps
    end
    add_index :deals, :code, :unique => true
  end
end
