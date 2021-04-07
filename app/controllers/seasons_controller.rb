class SeasonsController < ApplicationController
  def show
    @playerseason = PlayerSeason.where(user_id: current_user.id)
    @championship = Championship.where(id: current_user.player_seasons[0].championship.id)
    @playerseasons = PlayerSeason.where(championship_id: current_user.player_seasons[0].championship.id, season_id: Season.last.id)
  end

  def edit
    @playerseason = PlayerSeason.where(user_id: current_user.id)
    @forecasts = Forecast.where(season_id: Season.last.id, player_season_id: current_user.player_seasons[0].id)
  end
end
