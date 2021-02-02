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
    @users = User.all
    @playerseasons = PlayerSeason.where(season_id: Season.last.id)
  end
end
