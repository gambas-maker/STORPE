class Detruite < ActiveRecord::Migration[6.0]
  def change
    drop_table :friendships
  end
end
