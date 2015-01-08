class AddFeaturings < ActiveRecord::Migration
  def change
    create_table 'featurings' do |t|
      t.integer :charity_id, :null => false
      t.integer :merchant_id, :null => false
      t.integer :priority, :default => 0
    end
    add_index :featurings, :charity_id
    add_index :featurings, :merchant_id
  end
end
