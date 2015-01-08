class AddReportFieldsToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates,  :offer_cap_cents, :integer
    add_column :certificates,  :discount_rate,   :integer
    add_column :certificates,  :rules,           :text
    add_column :certificates,  :tagline,         :text
  end
end
