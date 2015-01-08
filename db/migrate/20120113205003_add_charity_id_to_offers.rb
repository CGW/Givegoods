class AddCharityIdToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :charity_id, :integer
    add_index :offers, :charity_id
  end
end
