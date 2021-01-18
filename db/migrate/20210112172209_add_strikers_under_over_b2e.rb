class AddStrikersUnderOverB2e < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :buteur_1, :string
    add_column :matches, :buteur_2, :string
    add_column :matches, :buteur_3, :string
    add_column :matches, :buteur_4, :string
    add_column :matches, :over_05, :string
    add_column :matches, :over_15, :string
    add_column :matches, :under_05, :string
    add_column :matches, :under_15, :string
    add_column :matches, :goal_two_teams, :string
  end
end
