class AddBtreeIndexToMerchantsName < ActiveRecord::Migration
  def change
    add_index :merchants, :name, :name => "index_merchants_on_name_with_btree"
  end
end
