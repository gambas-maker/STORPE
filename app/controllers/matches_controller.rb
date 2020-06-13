require_relative '../models/sport_odd'
class MatchesController < ApplicationController
  def index
    SportOdd.all_matches_for_week
    SportOdd.sort
    @matches = Match.all
  end
end
