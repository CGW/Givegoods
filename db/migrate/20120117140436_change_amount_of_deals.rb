class ChangeAmountOfDeals < ActiveRecord::Migration
  def up
    rename_column :deals, :amount, :amount_cents
    add_column :deals, :currency, :string, :null => false, :default => "USD"
  end

  def down
    rename_column :deals, :amount_cents, :amount
    remove_column :deals, :currency
  end
end
