class ChangeNameTable < ActiveRecord::Migration[6.0]
  def change
    rename_table :season_matches, :championships
  end
end
