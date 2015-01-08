class TakeTwoCharityDescriptionStringIntoText < ActiveRecord::Migration
  def change
   change_column :charities, :description, :text
  end
end


