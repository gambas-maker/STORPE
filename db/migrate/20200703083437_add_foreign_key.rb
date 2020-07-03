class AddForeignKey < ActiveRecord::Migration[6.0]
  def change
    add_reference :forecasts, :player_season, foreign_key: true
  end
end
