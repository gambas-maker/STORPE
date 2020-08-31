class ColumnUserNamedBlason < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :blason, :string
  end
end
