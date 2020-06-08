class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.string :result
      t.string :team_home
      t.string :team_away
      t.string :sport
      t.string :team_home_logo_url
      t.string :team_away_logo_url
      t.string :country
      t.string :league
      t.integer :points
      t.integer :negative_points
      t.string :kick_off
      t.timestamps
    end
  end
end
