class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string :name, :null => false, :limit => 100
      t.string :slug,  :null => false, :limit => 100
      t.decimal :lat, :precision => 11, :scale => 8
      t.decimal :lng, :precision => 11, :scale => 8
      t.timestamps
    end

    add_index :charities, :slug, :unique => true
  end
end
