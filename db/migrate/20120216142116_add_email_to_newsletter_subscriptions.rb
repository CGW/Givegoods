class AddEmailToNewsletterSubscriptions < ActiveRecord::Migration
  def change
    add_column :newsletter_subscriptions, :email, :string
    add_index :newsletter_subscriptions, :email
  end
end
