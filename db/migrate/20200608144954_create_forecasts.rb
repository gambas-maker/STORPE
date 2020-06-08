class CreateForecasts < ActiveRecord::Migration[6.0]
  def change
    create_table :forecasts do |t|
      t.references :player_season, null: false, foreign_key: true
      t.integer :points_win
      t.integer :points_lose
      t.boolean :confirmed

      t.timestamps
    end
  end
end
