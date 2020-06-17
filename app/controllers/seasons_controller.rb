class SeasonsController < ApplicationController
  def show
    @forecasts = Forecast.where(confirmed: true)
  end
end
