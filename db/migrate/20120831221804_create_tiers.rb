class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.string :tagline
      t.integer :amount_cents, :null => false, :default => 0
      t.references :campaign, :null => false
      t.timestamps
    end

    add_index :tiers, :campaign_id
  end
end
