class AddBtreeIndexToCharitiesName < ActiveRecord::Migration
  def change
    add_index :charities, :name, :name => "index_charities_on_name_with_btree"
  end
end
