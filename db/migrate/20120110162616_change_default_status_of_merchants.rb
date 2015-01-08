class ChangeDefaultStatusOfMerchants < ActiveRecord::Migration
  def up
    change_column_default :merchants, :status, "created"
    add_index :merchants, :status
  end

  def down
    change_column_default :merchants, :status, "pending"
    remove_index :merchants, :status
  end
end
