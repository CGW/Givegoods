class AddCubeAndEarthDistanceExtensions < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS cube 
    SQL

    execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS earthdistance
    SQL
  end

  def down
    execute <<-SQL
      DROP EXTENSION IF NOT EXISTS cube 
    SQL

    execute <<-SQL
      DROP EXTENSION IF NOT EXISTS earthdistance
    SQL
  end
end
