class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.integer :start_date
      t.integer :end_date
      t.string :division
      t.timestamps
    end
  end
end
