class RemoveBundleIdFromOffers < ActiveRecord::Migration
  def up
    remove_column :offers, :bundle_id
  end

  def down
    add_column :offers, :bundle_id, :integer
  end
end
