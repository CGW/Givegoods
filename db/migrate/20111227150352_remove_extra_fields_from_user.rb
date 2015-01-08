class RemoveExtraFieldsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :organization_title
    remove_column :users, :description
    remove_column :users, :phone_number
    remove_column :users, :website_url
    remove_column :users, :slug
    remove_column :users, :city
  end
end
