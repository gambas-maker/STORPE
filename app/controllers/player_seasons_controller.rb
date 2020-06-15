class PlayerSeasonsController < ApplicationController

  def show
    @forecasts = Forecast.where(confirmed: true)
  end
end
