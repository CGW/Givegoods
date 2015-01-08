class AlterCharityDescriptionStringToTextField < ActiveRecord::Migration
  def up
    change_column :charities, :description, :text
  end

  def down
    change_column :charities, :description, :string
  end
end
