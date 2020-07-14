class CreateChampionships < ActiveRecord::Migration[6.0]
  def change
    create_table :championships do |t|
      t.string :name
      t.date :strat_date
      t.date :end_date
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end
  end
end
