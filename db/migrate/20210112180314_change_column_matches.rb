class ChangeColumnMatches < ActiveRecord::Migration[6.0]
  def change
    change_column :matches, :buteur_1, "float USING CAST(buteur_1 AS float)"
    change_column :matches, :buteur_2, "float USING CAST(buteur_2 AS float)"
    change_column :matches, :buteur_3, "float USING CAST(buteur_3 AS float)"
    change_column :matches, :buteur_4, "float USING CAST(buteur_4 AS float)"
    change_column :matches, :over_05, "float USING CAST(over_05 AS float)"
    change_column :matches, :over_15, "float USING CAST(over_15 AS float)"
    change_column :matches, :under_05, "float USING CAST(under_05 AS float)"
    change_column :matches, :under_15, "float USING CAST(under_15 AS float)"
    change_column :matches, :goal_two_teams, "float USING CAST(goal_two_teams AS float)"
  end
end
