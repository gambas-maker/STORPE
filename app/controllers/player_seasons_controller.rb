class PlayerSeasonsController < ApplicationController

  def show
    @forecasts = Forecast.where(confirmed: true)
    @championship = Championship.where(id: current_user.player_seasons[0].championship.id)
  end
end
