class ChangeType < ActiveRecord::Migration[6.0]
  def change
    change_column :matches, :result, :string
  end
end
