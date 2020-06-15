require_relative '../models/sport_odd'
class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end
end
