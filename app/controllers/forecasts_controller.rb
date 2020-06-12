class ForecastsController < ApplicationController
  def show
    @forecast = Forecast.find(match.id)
  end

  def new
    @match = Match.find(params[:match_id])
    @forecast = Forecast.new
  end

  def create
    @forecast = Forecast.new(forecast_params)
    @forecast.user = current_user
    @forecast.match = Match.find(params[:match_id])

    if @forecast.save
      redirect_to matchs_path
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

  def confirm_pending
  end

  private

  def forecast_params
    parmas.require(:forecast).permit(:outcome)
  end
end
