class ChangeAmountColumnOfCertificates < ActiveRecord::Migration
  def up
    rename_column :certificates, :amount, :amount_cents
    add_column :certificates, :currency, :string, :null => false, :default => "USD"
  end

  def down
    remove_column :certificates, :currency
    rename_column :certificates, :amount_cents, :amount
  end
end
