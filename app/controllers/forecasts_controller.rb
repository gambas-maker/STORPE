class ForecastsController < ApplicationController
  def show
    @forecast = Forecast.find(match.id)
  end

  def new
    @m = Match.find(params[:match_id])
    @forecast = Forecast.new
  end

  def create
    @m = Match.find(params[:match_id])
    @forecast = Forecast.new(forecast_params)
    @forecast.player_season_id = current_user
    @forecast.m = Match.find(params[:match_id])

    if @forecast.save
      redirect_to matches_path
    else
      render :new
    end
  end

  def destroy
    @forecast = Forecast.find(params[:id])
    @forecast.destroy
    redirect_to forecasts_path
    # Verifiez le chemin, peut etre confirm pending path?
  end

  def store_outcome
    id = params[:match]
    # match = Match.find(id)
    outcome = params[:result]
    player = current_user.player_season_ids
    @forecast = Forecast.where(match: id, player_season: player).first
    if @forecast.nil?
    @playerseason = PlayerSeason.create!(user_id: current_user.id, season_id: 4)
    @forecast = Forecast.new
    @forecast.outcome = outcome
    @forecast.match_id = id
    @forecast.player_season_id = player[0]
    @forecast.confirmed = false
    @forecast.save!
    else
    @forecast.outcome = outcome
    @forecast.save
    end
    render json: { status: @forecast }
  end

  def confirm_pending
    player = PlayerSeason.find(current_user.player_season_ids)
    @forecasts = Forecast.where(confirmed: false, player_season: player)
    @forecasts.update(confirmed: true)

    render json: { status: "succes" }
  end

  private

  def forecast_params
    params.require(:forecast).permit(:outcome)
  end
end
