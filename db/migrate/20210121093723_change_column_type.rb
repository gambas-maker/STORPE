class ChangeColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :seasons, :start_date, :string
    change_column :seasons, :end_date, :string
  end
end
