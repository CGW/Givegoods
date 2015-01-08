class AddAmountToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :amount, :integer
  end
end
