class CharityDescriptionToText < ActiveRecord::Migration
  def change
   change_column :charities, :description, :string, :limit => 2500
  end
end
