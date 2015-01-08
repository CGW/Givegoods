class AddImageToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates, :image, :string
  end
end
