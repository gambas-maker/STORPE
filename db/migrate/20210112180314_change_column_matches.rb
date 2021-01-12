class ChangeColumnMatches < ActiveRecord::Migration[6.0]
  def change
    change_column :matches, :buteur_1, :float
    change_column :matches, :buteur_2, :float
    change_column :matches, :buteur_3, :float
    change_column :matches, :buteur_4, :float
    change_column :matches, :over_05, :float
    change_column :matches, :over_15, :float
    change_column :matches, :under_05, :float
    change_column :matches, :under_15, :float
    change_column :matches, :goal_two_teams, :float
  end
end
