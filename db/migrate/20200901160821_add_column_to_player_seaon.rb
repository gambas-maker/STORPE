class AddColumnToPlayerSeaon < ActiveRecord::Migration[6.0]
  def change
    add_column :player_seasons, :blason, :string
  end
end
