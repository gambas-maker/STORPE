class SeasonsController < ApplicationController
  def show
    @championships = Championship.where(season_id: Season.last.id)
    @playerseason = PlayerSeason.where(user_id: current_user.id)
    @playerseasons = PlayerSeason.where(season_id: Season.last.id)
    @season = Season.last
    @forecasts = Forecast.where(confirmed: true)
  end
end
