class AddBundleIdToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :bundle_id, :integer
  end
end
