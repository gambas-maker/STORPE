class Offforeignkey < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :blason_id
  end
end
