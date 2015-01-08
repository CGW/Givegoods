class AddFeaturedToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :featured, :boolean, :default => false, :null => false
    add_index :offers, :featured
  end
end
