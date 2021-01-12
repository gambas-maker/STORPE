class AddColumnToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :goals_two_teams_no, :float
    rename_column :matches, :goals_two_teams, :goals_two_teams_yes
  end
end
