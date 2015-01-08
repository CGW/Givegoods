class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.date :date_from
      t.date :date_to
    end
  end
end
