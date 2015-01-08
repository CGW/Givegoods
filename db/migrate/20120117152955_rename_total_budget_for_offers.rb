class RenameTotalBudgetForOffers < ActiveRecord::Migration
  def up
    rename_column :offers, :total_budget, :total_budget_cents
  end

  def down
    rename_column :offers, :total_budget_cents, :total_budget
  end
end
