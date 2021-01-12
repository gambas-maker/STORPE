class ChangeColumnMatches < ActiveRecord::Migration[6.0]
  def change
    change_column :matches, :buteur_1, :float, "USING buteur_1::double precision"
    change_column :matches, :buteur_2, :float, "USING buteur_2::double precision"
    change_column :matches, :buteur_3, :float, "USING buteur_3::double precision"
    change_column :matches, :buteur_4, :float, "USING buteur_4::double precision"
    change_column :matches, :over_05, :float, "USING over_05::double precision"
    change_column :matches, :over_15, :float, "USING over_15::double precision"
    change_column :matches, :under_05, :float, "USING under_05::double precision"
    change_column :matches, :under_15, :float, "USING under_15::double precision"
    change_column :matches, :goal_two_teams, :float, "USING goal_two_teams::double precision"
  end
end
