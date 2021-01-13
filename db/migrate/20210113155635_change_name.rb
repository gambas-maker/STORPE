class ChangeName < ActiveRecord::Migration[6.0]
  def change
    rename_column :matches, :under25, :under_25
    rename_column :matches, :goals_two_teams_yes, :goal_two_teams_yes
    rename_column :matches, :negative_goals_two_teams_yes, :negative_goal_two_teams_yes
  end
end
