class ChangeOfferFields < ActiveRecord::Migration
  def up
    remove_column :offers, :monthly_budget_cents
    remove_column :offers, :one_certificate

    add_column :offers, :discount_rate, :integer
    add_column :offers, :offer_cap_cents, :integer
    add_column :offers, :max_certificates, :integer
    add_column :offers, :tagline, :text
    change_column :offers, :currency, :string, :limit => 3, :default => "USD"
  end

  def down
    remove_column :offers, :discount_rate
    remove_column :offers, :offer_cap_cents
    remove_column :offers, :max_certificates
    remove_column :offers, :tagline

    add_column :offers, :monthly_budget_cents, :integer
    add_column :offers, :one_certificate, :boolean, :default => false
  end
end
