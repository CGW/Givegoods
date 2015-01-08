class AddStatusToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :status, :string, :default => 'pending'
  end
end
