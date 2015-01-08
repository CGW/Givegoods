class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.integer :user_id
      t.string  :name
      t.text    :description
      t.string  :website_url
      t.string  :picture
      t.timestamps
    end
  end
end
