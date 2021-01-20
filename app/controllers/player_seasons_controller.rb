class PlayerSeasonsController < ApplicationController
  def show
    @forecasts = Forecast.where(confirmed: true)
    @championship = Championship.where(id: current_user.player_seasons[0].championship.id)
    @seasons = Season.all
  end

  def edit
    @playerseason = PlayerSeason.find(params[:id])
  end

  def update
    @playerseason = PlayerSeason.find(params[:id])
    @playerseason.update(player_params)

    redirect_to season_path(params[:id])
  end

  private

  def player_params
    params.require(:player_season).permit(:blason)
  end
end
