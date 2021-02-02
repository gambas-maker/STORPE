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
    @matches = Match.select { |v| v.event_stamp == Date.today.to_s }
    @forecasts = Forecast.where(season_id: Season.last.id, confirmed: true)
    @playerseasons = PlayerSeason.select { |k| k.number_of_points > 0 }
  end
end
