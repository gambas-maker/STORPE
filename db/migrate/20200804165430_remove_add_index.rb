class RemoveAddIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, :pseudo
  end
end
