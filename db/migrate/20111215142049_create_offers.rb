class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :user_id, :null => false
      t.string :title
      t.text :description
      t.text :rules
      t.integer :price_cents
      t.string :price_currency, :limit => 3
      t.string :quantity
      t.string :slug
      t.timestamps
    end
    add_index :offers, :user_id
    add_index :offers, :slug
  end
end
