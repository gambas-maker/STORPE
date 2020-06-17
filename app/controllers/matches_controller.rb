require_relative '../models/sport_odd'
class MatchesController < ApplicationController
  def index
    @forecasts = Forecast.where(confirmed: false)
    @matches = Match.all
    @player = 1
    league_filters
  end

  def league_filters
    if params[:query].present?
      @matches = Match.where(country: params[:query])
    else
      @matches = Match.all
    end
  end
end
