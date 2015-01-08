class AddMerchantRoleToUsersWithMerchants < ActiveRecord::Migration
  def up
    User.where(:role => nil).joins(:merchant).where("merchants.id is not null").update_all(:role => 'merchant')
  end 

  def down
  end
end
