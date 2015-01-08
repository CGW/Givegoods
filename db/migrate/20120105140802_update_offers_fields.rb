class UpdateOffersFields < ActiveRecord::Migration
  def change
    rename_column :offers, :user_id, :merchant_id
    add_column :offers, :total_budget, :integer
    add_column :offers, :status, :string, :default => 'paused'
    add_column :offers, :one_certificate, :boolean, :default => false
  end
end
