class AddNotesToBundles < ActiveRecord::Migration
  def change
    add_column :bundles, :notes, :string
  end
end
