class AddIndexOnNameToCharitiesAndMerchants < ActiveRecord::Migration
  def up
    # charities name index
    execute 'DROP INDEX IF EXISTS index_charities_on_name'
    execute "CREATE INDEX index_charities_on_name ON charities USING gist(to_tsvector('english', name))"

    # merchants name index
    execute "DROP INDEX IF EXISTS index_merchants_on_name"
    execute "CREATE INDEX index_merchants_on_name ON merchants USING gist(to_tsvector('english', name))"
  end

  def down
    execute 'DROP INDEX IF EXISTS index_charities_on_name'
    execute "DROP INDEX IF EXISTS index_merchants_on_name"
  end
end
