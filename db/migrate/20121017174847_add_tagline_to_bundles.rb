class AddTaglineToBundles < ActiveRecord::Migration
  def change
    add_column :bundles, :tagline, :string
  end
end
