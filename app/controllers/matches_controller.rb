require_relative '../models/sport_odd'
class MatchesController < ApplicationController
  def index
    @matches = Match.select { |v| v.event_stamp == Date.today.to_s || v.event_stamp == Date.tomorrow.to_s || v.event_stamp == (Date.tomorrow + 1).to_s }
    league_filters
  end

  def league_filters
    if params[:query].present?
      @matches = Match.where(league: params[:query])
    else
      @matches
    end
  end
end
