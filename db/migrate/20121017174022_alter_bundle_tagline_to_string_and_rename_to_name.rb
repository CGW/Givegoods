class AlterBundleTaglineToStringAndRenameToName < ActiveRecord::Migration
  def up
    execute <<-SQL
      alter table bundles
        alter tagline type varchar(255)
    SQL

    execute <<-SQL
      alter table bundles
        rename column tagline to name
    SQL
  end

  def down
    execute <<-SQL
      alter table bundles
        rename column name to tagline
    SQL

    execute <<-SQL
      alter table bundles
        alter tagline type text
    SQL
  end
end
