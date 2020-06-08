class AddReference < ActiveRecord::Migration[6.0]
  def change
    add_reference :forecasts, :match, foreign_key: true
  end
end
