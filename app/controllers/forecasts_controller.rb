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


  end


  def confirm_pending
  end

  private

  def forecast_params
    params.require(:forecast).permit(:outcome)
  end
end
