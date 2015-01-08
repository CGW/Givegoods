class AddPictureToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :picture, :string
  end
end
