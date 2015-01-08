class CreateBundles < ActiveRecord::Migration
  def change
    create_table :bundles do |t|
      t.integer :donation_value_cents
      t.integer :charity_id
      t.string  :status, :default => 'inactive'
      t.string  :image
      t.text    :tagline
      t.timestamps
    end
    
    add_index :bundles, :charity_id
    
    add_column :offers, :bundle_id, :integer
  end
end
