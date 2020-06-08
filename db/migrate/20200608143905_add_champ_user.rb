class AddChampUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :pseudo, :string
    add_column :users, :last_name, :string
  end
end
