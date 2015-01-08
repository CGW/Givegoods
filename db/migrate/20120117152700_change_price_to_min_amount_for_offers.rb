class ChangePriceToMinAmountForOffers < ActiveRecord::Migration
  def up
    rename_column :offers, :price_cents, :min_amount_cents
    rename_column :offers, :price_currency, :currency
  end

  def down
    rename_column :offers, :min_amount_cents, :price_cents
    rename_column :offers, :currency, :price_currency
  end
end
