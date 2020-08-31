class AddColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :blasons, :name, :string
    add_column :blasons, :url, :string
  end
end
