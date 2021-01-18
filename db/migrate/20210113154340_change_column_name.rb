class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :matches, :over_05, :over_25
    rename_column :matches, :negative_over0, :negative_over25
    rename_column :matches, :negative_under15, :negative_under25
    rename_column :matches, :under_15, :under25
    remove_column :matches, :over_15
    remove_column :matches, :under_05
    remove_column :matches, :negative_under05
    remove_column :matches, :negative_over15
  end
end
