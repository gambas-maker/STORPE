class SeasonsController < ApplicationController
  def show
    @season = Season.last
    @forecasts = Forecast.where(confirmed: true)
  end
end
