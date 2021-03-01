class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def about
  end

  def contact
  end

  def rules
  end

  def settings
    @blasons = Blason.all
  end

  def confidentialite
  end

  def dashboard
    @matchestoday = Match.where(event_stamp: Date.today.to_s, sport: "football")
    @matchestomorrow = Match.where(event_stamp: Date.tomorrow.to_s, sport: "football")
    @matchesdayafter = Match.where(event_stamp: (Date.tomorrow+1).to_s, sport: "football")
    @matchesbasketoday = Match.where(event_stamp: Date.tomorrow.to_s, sport: "basketball")
    @matches = Match.where(event_stamp: Date.yesterday.to_s, sport: "football")
    @matchesbasket = Match.where(event_stamp: Date.today.to_s, sport: "basketball")
    @playerseasons = PlayerSeason.where(season_id: Season.last.id)
    @playerschamp = PlayerSeason.where(season_id: Season.last.id, championship_id: 255)
    @playerspro = PlayerSeason.where(season_id: Season.last.id, championship_id: 61 || 233 || 252)
    @playerssemi = PlayerSeason.where(season_id: Season.last.id, championship_id: 4 || 21 || 22 || 23 || 62 || 63)
    @playersama = PlayerSeason.where(season_id: Season.last.id, championship_id: 1 || 6 || 7 || 8 || 9 || 10 || 11 || 12 || 13 || 14 || 15 || 16 || 17 || 18 || 19 || 20)
  end
end
