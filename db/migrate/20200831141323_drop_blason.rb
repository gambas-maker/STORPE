class DropBlason < ActiveRecord::Migration[6.0]
  def change
    drop_table :blasons
  end
end
