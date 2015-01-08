class AddIndexOnLatLngToCharitiesAndMerchants < ActiveRecord::Migration
  def up
    # charities lat/lng index
    execute "DROP INDEX IF EXISTS index_charities_on_lng_lat"
    execute "CREATE INDEX index_charities_on_lng_lat ON charities USING gist (ll_to_earth(lat, lng))"

    # merchants lat/lng index
    execute "DROP INDEX IF EXISTS index_merchants_on_lng_lat"
    execute "CREATE INDEX index_merchants_on_lng_lat ON merchants USING gist (ll_to_earth(lat, lng))"
  end

  def down
    execute "DROP INDEX IF EXISTS index_charities_on_lng_lat"
    execute "DROP INDEX IF EXISTS index_merchants_on_lng_lat"
  end
end
