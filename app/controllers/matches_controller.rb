require_relative '../models/sport_odd'
class MatchesController < ApplicationController
  def index
    @forecasts = Forecast.where(confirmed: false)
    @matches = Match.all
    @player = 1
  end
end
