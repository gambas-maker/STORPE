class ChangeColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :seasons, :start_date, "string USING CAST(start_date AS string)"
    change_column :seasons, :end_date, "string USING CAST(end_date AS string)"
  end
end
