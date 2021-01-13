class AddNegativePointsButeurs < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :negative_points_buteur1, :integer
    add_column :matches, :negative_points_buteur2, :integer
    add_column :matches, :negative_points_buteur3, :integer
    add_column :matches, :negative_points_buteur4, :integer
  end
end
