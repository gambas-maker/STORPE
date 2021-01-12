class AddStrikersUnderOverB2e < ActiveRecord::Migration[6.0]
  def change
    add_column :matchs, :buteur_1, :string
    add_column :matchs, :buteur_2, :string
    add_column :matchs, :buteur_3, :string
    add_column :matchs, :buteur_4, :string
    add_column :matchs, :over_05, :string
    add_column :matchs, :over_15, :string
    add_column :matchs, :under_05, :string
    add_column :matchs, :under_15, :string
    add_column :matchs, :goal_two_teams, :string
  end
end
