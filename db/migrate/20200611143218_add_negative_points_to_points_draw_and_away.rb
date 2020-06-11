class AddNegativePointsToPointsDrawAndAway < ActiveRecord::Migration[6.0]
  def change
    rename_column :matches, :negative_points, :negative_points_home
    add_column :matches, :negative_points_draw, :integer
    add_column :matches, :negative_points_away, :integer
  end
end
