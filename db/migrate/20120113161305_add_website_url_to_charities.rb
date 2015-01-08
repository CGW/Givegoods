class AddWebsiteUrlToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :website_url, :string
  end
end
