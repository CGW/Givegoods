class ChangeMerchantInitialStatus < ActiveRecord::Migration
  def up
    change_column_default :merchants, :status, "unconfirmed"
    Merchant.where(:status => 'created').update_all(:status => 'unconfirmed')
  end

  def down
    change_column_default :merchants, :status, "created"
    Merchant.where(:status => 'unconfirmed').update_all(:status => 'created')
  end
end
