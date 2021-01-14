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
        @forecasts.each do |forecast|
          if forecast.where(match_id: id).outcome == "1" || "NULL" || "2"
            forecast.update(outcome: outcome)
          elsif forecast.where(match_id: id).outcome == "1" || "NULL" || "2"
            forecast.update(outcome: outcome)
          elsif forecast.where(match_id: id).outcome == "7" || "8"
            forecast.update(outcome: outcome)
          elsif forecast.where(match_id: id).outcome == "9" || "10"
            forecast.update(outcome: outcome)
          else
            Forecast.create(match_id: id, player_season_id: player[0], points_lose: 0, points_win: 0, season_id: Season.last.id, confirmed: false, outcome: outcome)
          end
        end
        # @forecast = Forecast.where(match_id: id, player_season_id: player[0])
        # if @forecast.nil?
        #   @forecast = Forecast.create(match_id: id, player_season_id: player[0], points_lose: 0, points_win: 0, season_id: Season.last.id, confirmed: false, outcome: outcome)
        # elsif @forecast.outcome == "1" || "NULL" || "2"
        #   @forecast.update(outcome: outcome)
        # elsif forecast.outcome == "7" || "8"
        #   @forecast.update(outcome: outcome)
        # elsif forecast.outcome == "9" || "10"
        #   @forecast.update(outcome: outcome)
        # # elsif
        # #   @forecast = Forecast.create(match_id: id, player_season_id: player[0], points_lose: 0, points_win: 0, season_id: Season.last.id, confirmed: false, outcome: outcome)
        # else
        #   @forecast.outcome = outcome
        #   @forecast.save
        # end
      else check == "false"
        @forecast = Forecast.where(match: id, player_season: player, confirmed: false)
        @forecast.destroy_all
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
