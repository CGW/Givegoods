class AddStatusToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :status, :string, :default => "inactive", :null => false
    add_index :charities, :status
  end
end
