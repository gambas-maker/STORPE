class AddForeignKey < ActiveRecord::Migration[6.0]
  def change

  add_reference :player_seasons, :championship, foreign_key: true
  end
end
