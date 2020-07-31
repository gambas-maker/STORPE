require_relative '../models/sport_odd'
class MatchesController < ApplicationController
  def index
    @forecasts = Forecast.where(confirmed: true)
    @matches = Match.all
    @player = 1
    league_filters
  end

  def league_filters
    if params[:sport] == "Football"
      if params[:query].present?
        @matches = Match.where(country: params[:query])
      else
        @matches = Match.where(sport: "football")
      end
    else params[:sport] == "Basketball"
      if params[:query].present?
        @matches = Match.where(league: params[:query])
      else
        @matches = Match.where(sport: "basketball")
      end
    end
  end
end
