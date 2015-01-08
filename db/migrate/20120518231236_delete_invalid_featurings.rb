class DeleteInvalidFeaturings < ActiveRecord::Migration
  def up
    Featuring.all.each do |featuring|
      featuring.destroy if featuring.invalid?
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
