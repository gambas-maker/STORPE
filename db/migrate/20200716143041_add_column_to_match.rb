class AddColumnToMatch < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :event_stamp, :string
  end
end
