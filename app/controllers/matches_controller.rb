require_relative '../models/sport_odd'
class MatchesController < ApplicationController
  def index
    SportOdd.matches_for_week(524)
    @matches = Match.all
  end
end
