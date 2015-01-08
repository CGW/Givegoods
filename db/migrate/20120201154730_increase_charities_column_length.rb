class IncreaseCharitiesColumnLength < ActiveRecord::Migration
  def up
    change_column :charities, :temp_image_url, :text
    change_column :charities, :temp_image_url2, :text
    change_column :charities, :website_url, :text
  end

  def down
    change_column :charities, :temp_image_url, :string
    change_column :charities, :temp_image_url2, :string
    change_column :charities, :website_url, :string
  end
end
