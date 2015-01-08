class AddExtraFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_name,         :string
    add_column :users, :last_name,          :string
    add_column :users, :organization_title, :string
    add_column :users, :description,        :string
    add_column :users, :phone_number,       :string
    add_column :users, :website_url,        :string

    add_column :users, :slug,               :string
    add_index  :users, :slug
  end
end
