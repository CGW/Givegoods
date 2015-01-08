class ModifyBudgetColumnsForOffers < ActiveRecord::Migration
  def up
    rename_column :offers, :total_budget_cents, :monthly_budget_cents
    remove_column :offers, :min_amount_cents
  end

  def down
    rename_column :offers, :monthly_budget_cents, :total_budget_cents
    add_column :offers, :min_amount_cents, :integer
  end
end
