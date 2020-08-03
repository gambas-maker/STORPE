class ChangeMatchTable < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :result_home, :integer
    add_column :matches, :result_away, :integer
  end
end
