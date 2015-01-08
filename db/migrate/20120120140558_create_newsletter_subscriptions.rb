class CreateNewsletterSubscriptions < ActiveRecord::Migration
  def change
    create_table :newsletter_subscriptions do |t|
      t.column :customer_id, :integer
      t.column :charity_id, :integer
      t.column :merchant_id, :integer
      t.timestamps
    end
    add_index :newsletter_subscriptions, :customer_id
    add_index :newsletter_subscriptions, :charity_id
    add_index :newsletter_subscriptions, :merchant_id
  end
end
