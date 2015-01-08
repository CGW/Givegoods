class CreateBundlings < ActiveRecord::Migration
  def change
    create_table :bundlings do |t|
      t.references :bundle, :null => false
      t.references :offer, :null => false
      t.timestamps
    end
    add_index :bundlings, [:bundle_id, :offer_id], :unique => true
    add_index :bundlings, :offer_id
  end
end
