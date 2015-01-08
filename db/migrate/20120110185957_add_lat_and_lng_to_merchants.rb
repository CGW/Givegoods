class AddLatAndLngToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :lat, :decimal, :precision => 11, :scale => 8
    add_column :merchants, :lng, :decimal, :precision => 11, :scale => 8
  end
end
