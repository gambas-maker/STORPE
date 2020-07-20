class ChangeDataType < ActiveRecord::Migration[6.0]
  def change
    change_column :matches, :result, 'integer USING CAST(result AS integer)'
  end
end
