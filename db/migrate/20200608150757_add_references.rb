class AddReferences < ActiveRecord::Migration[6.0]
  def change
    add_reference :player_seasons, :season, foreign_key: true
    add_reference :season_matches, :season, foreign_key: true
  end
end
