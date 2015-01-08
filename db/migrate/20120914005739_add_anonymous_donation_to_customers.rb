class AddAnonymousDonationToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :anonymous_donation, :boolean, :default => false
  end
end
