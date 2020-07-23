class SeasonsController < ApplicationController
  def show
    @championships = Championship.where(season_id: Season.last.id)
    @playerseason = PlayerSeason.where(user_id: current_user.id)
    @championship = Championship.where(id: current_user.player_seasons[0].championship.id)
    @playerseasons = PlayerSeason.where(championship_id: current_user.player_seasons[0].championship.id)
    @season = Season.last
    @forecasts = Forecast.where(confirmed: true)
  end
end
