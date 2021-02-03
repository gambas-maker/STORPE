class ForecastsController < ApplicationController
  respond_to :html
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
        @forecast = Forecast.where(match: id, player_season: player, outcome: "1") || Forecast.where(match: id, player_season: player, outcome: "NULL") || Forecast.where(match: id, player_season: player, outcome: "2")
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

  def store_outcome_b2e
    @forecasts = Forecast.where(player_season_id: current_user.player_seasons.ids, season_id: Season.last.id)
    id = params[:match]
    # match = Match.find(id)
    outcome = params[:result]
    check = params[:box]
    player = current_user.player_season_ids
    if @forecasts.count < 40
      if check == "true"
        @forecastb2e = Forecast.where(match: id, player_season: player, outcome: "7" || "8").first
        if @forecastb2e.nil?
          @forecastb2e = Forecast.new
          @forecastb2e.outcome = outcome
          @forecastb2e.match_id = id
          @forecastb2e.points_win = 0
          @forecastb2e.points_lose = 0
          @forecastb2e.player_season_id = player[0]
          @forecastb2e.season_id = Season.last.id
          @forecastb2e.confirmed = false
          @forecastb2e.save!
        else
          @forecastb2e.outcome = outcome
          @forecastb2e.save
        end
      else check == "false"
        @forecastb2e = Forecast.where(match: id, player_season: player).first
        @forecastb2e.destroy
      end
    else
    end
   render json: { status: @forecast }
  end

  def store_outcome_under
    @forecasts = Forecast.where(player_season_id: current_user.player_seasons.ids, season_id: Season.last.id)
    id = params[:match]
    # match = Match.find(id)
    outcome = params[:result]
    check = params[:box]
    player = current_user.player_season_ids
    if @forecasts.count < 40
      if check == "true"
        @forecastb2e = Forecast.where(match: id, player_season: player, outcome: "9" || "10").first
        if @forecastb2e.nil?
          @forecastb2e = Forecast.new
          @forecastb2e.outcome = outcome
          @forecastb2e.match_id = id
          @forecastb2e.points_win = 0
          @forecastb2e.points_lose = 0
          @forecastb2e.player_season_id = player[0]
          @forecastb2e.season_id = Season.last.id
          @forecastb2e.confirmed = false
          @forecastb2e.save!
        else
          @forecastb2e.outcome = outcome
          @forecastb2e.save
        end
      else check == "false"
        @forecastb2e = Forecast.where(match: id, player_season: player).first
        @forecastb2e.destroy
      end
    else
    end
    render json: { status: @forecast }
  end

  def store_outcome_striker1
    @forecasts = Forecast.where(player_season_id: current_user.player_seasons.ids, season_id: Season.last.id)
    id = params[:match]
    # match = Match.find(id)
    outcome = params[:result]
    check = params[:box]
    player = current_user.player_season_ids
    if @forecasts.count < 40
      if check == "true"
        @forecaststriker1 = Forecast.where(match: id, player_season: player, outcome: "3" || "4")
        if @forecaststriker1.nil?
          @forecaststriker1 = Forecast.new
          @forecaststriker1.outcome = outcome
          @forecaststriker1.match_id = id
          @forecaststriker1.points_win = 0
          @forecaststriker1.points_lose = 0
          @forecaststriker1.player_season_id = player[0]
          @forecaststriker1.season_id = Season.last.id
          @forecaststriker1.confirmed = false
          @forecaststriker1.save!
        else
          @forecaststriker1 = Forecast.new
          @forecaststriker1.outcome = outcome
          @forecaststriker1.match_id = id
          @forecaststriker1.points_win = 0
          @forecaststriker1.points_lose = 0
          @forecaststriker1.player_season_id = player[0]
          @forecaststriker1.season_id = Season.last.id
          @forecaststriker1.confirmed = false
          @forecaststriker1.save!
        end
      else check == "false"
        @forecaststriker1 = Forecast.where(match: id, player_season: player, outcome: outcome)
        @forecaststriker1.destroy_all
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
