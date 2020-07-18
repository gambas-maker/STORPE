class CalculatepointsJob < ApplicationJob
  queue_as :default
  def perform
    @matches = Match.where(event_stamp: Date.today.to_s)
    @forecasts = Forecast.where(season_id: Season.last.id)
    @playerseason = PlayerSeason.where(user_id: current_user.id)
    points = 0
    @matches.each do |match|
      match.forecasts.each do |forecast|
        if forecast.outcome == match.result
          if forecast.outcome == "1"
            points += match.points_home
          elsif forecast.outcome == "N"
            points += match.points_draw
          elsif forecast.outcome == "2"
            points += match.points_away
          end
          forecast.update(points_win: points)
        else
          if forecast.outcome == "1"
            points += match.negative_points_home
          elsif forecast.outcome == "N"
            points += match.negative_points_draw
          elsif forecast.outcome == "2"
            points += match.negative_points_away
          end
          forecast.update(points_lose: points)
        end
      end
    end
    @forecasts.each do |forecast|
      if forecast.points_win.exists?
        @playerseason.
      end
    end
  end
end
