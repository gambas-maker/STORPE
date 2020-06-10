class AddLineToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :points_draw, :float
    add_column :matches, :points_away, :float
    add_column :matches, :fixture_id, :integer
    rename_column :matches, :points, :points_home
    change_column :matches, :points_home, :float
  end
end
