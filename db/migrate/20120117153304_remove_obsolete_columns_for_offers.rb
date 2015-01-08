class RemoveObsoleteColumnsForOffers < ActiveRecord::Migration
  def up
    remove_column :offers, :title
    remove_column :offers, :description
    remove_column :offers, :slug
    remove_column :offers, :quantity
    remove_column :offers, :featured
  end

  def down
    add_column :offers, :featured, :boolean
    add_column :offers, :quantity, :integer
    add_column :offers, :slug, :string
    add_column :offers, :description, :text
    add_column :offers, :title, :string
  end
end
