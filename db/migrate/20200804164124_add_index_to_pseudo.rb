class AddIndexToPseudo < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :pseudo, :unique => true
  end
end
