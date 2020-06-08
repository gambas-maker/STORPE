class CreatePlayerSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :player_seasons do |t|
      t.references :user, null: false, foreign_key: true
      t.float :ratio
      t.integer :rank
      t.integer :number_of_points
      t.timestamps
    end
  end
end
