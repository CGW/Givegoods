class AddRegisteredAtAndActivatedAtToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :registered_at, :datetime
    add_column :merchants, :activated_at, :datetime
  end
end
