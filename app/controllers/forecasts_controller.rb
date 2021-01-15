class ForecastsController < ApplicationController
  respond_to :html
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
    # Verifiez le chemin, peut etre confirm pending path?
  end

  def store_outcome
    @forecasts = Forecast.where(player_season_id: current_user.player_seasons.ids, season_id: Season.last.id)
    id = params[:match]
    # match = Match.find(id)
    outcome = params[:result]
    check = params[:box]
    player = current_user.player_season_ids
    if @forecasts.count < 40
      if check == "true"
        @forecast = Forecast.where(match: id, player_season: player).first
        if @forecast.nil?
          @forecast = Forecast.new
          @forecast.outcome = outcome
          @forecast.match_id = id
          @forecast.points_win = 0
          @forecast.points_lose = 0
          @forecast.player_season_id = player[0]
          @forecast.season_id = Season.last.id
          @forecast.confirmed = false
          @forecast.save!
        else
          @forecast.outcome = outcome
          @forecast.save
        end
      else check == "false"
         @forecast = Forecast.where(match: id, player_season: player).first
        @forecast.destroy
      end
    else
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
