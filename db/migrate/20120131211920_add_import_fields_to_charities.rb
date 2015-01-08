class AddImportFieldsToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :ein, :string
    add_column :charities, :temp_image_url, :string
    add_column :charities, :temp_image_url2, :string
    add_column :charities, :metro_area_name, :string
    add_index  :charities, :ein, :unique => true
  end
end
