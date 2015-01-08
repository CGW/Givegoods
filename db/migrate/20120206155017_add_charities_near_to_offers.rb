class AddCharitiesNearToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :charities_near, :string
    add_column :offers, :lat, :decimal, :precision => 11, :scale => 8
    add_column :offers, :lng, :decimal, :precision => 11, :scale => 8
  end
end
