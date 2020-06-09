class AddOutcomeColumnToForecast < ActiveRecord::Migration[6.0]
  def change
    add_column :forecasts, :outcome, :string
  end
end
