class AddNegativePoints < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :negative_goals_two_teams_yes, :integer
    add_column :matches, :negative_goal_two_teams_no, :integer
    add_column :matches, :negative_over0, :integer
    add_column :matches, :negative_over15, :integer
    add_column :matches, :negative_under05, :integer
    add_column :matches, :negative_under15, :integer
  end
end
