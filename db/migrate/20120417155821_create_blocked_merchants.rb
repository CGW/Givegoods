class CreateBlockedMerchants < ActiveRecord::Migration
  def change
    create_table 'charities_merchants', :id => false do |t|
      t.integer :charity_id, :null => false
      t.integer :merchant_id, :null => false
    end
    add_index :charities_merchants, ["charity_id", "merchant_id"], :name => "fk_charity_merchant"
  end
end
