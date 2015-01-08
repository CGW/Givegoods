class AddDonationValueCentsToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates,  :donation_value_cents, :integer
  end
end
