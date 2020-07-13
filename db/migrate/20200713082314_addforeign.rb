class Addforeign < ActiveRecord::Migration[6.0]
  def change
    add_reference :forecasts, :season, foreign_key: true
  end
end
