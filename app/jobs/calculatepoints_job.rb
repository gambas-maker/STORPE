class CalculatepointsJob < ApplicationJob
  queue_as :default
  def perform
    @matches = Match.where(event_stamp: Date.today.to_s)
    @forecasts = Forecast.where(season_id: Season.last.id)
    @matches.each do |match|
      match.forecasts.each do |forecast|
        if forecast.outcome == match.result
          if forecast.outcome == "1"
            forecast.points_win += match.points_home
          elsif forecast.outcome == "N"
            forecast.points_win += match.points_draw
          elsif forecast.outcome == "2"
            forecast.points_win += match.points_away
          end
        else
          if forecast.outcome == "1"
            forecast.points_lose += match.negative_points_home
          elsif forecast.outcome == "N"
            forecast.points_lose += match.negative_points_draw
          elsif forecast.outcome == "2"
            forecast.points_lose += match.negative_points_away
          end
        end
      end
    end
  end
end
