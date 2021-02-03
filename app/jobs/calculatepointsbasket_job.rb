class CalculatepointsbasketJob < ApplicationJob
  queue_as :default

  def perform
    @matches = Match.where(sport: "basketball", event_stamp: Date.today.to_s)
    @forecasts = Forecast.where(season_id: Season.last.id, confirmed: true)
    @matches.each do |match|
      match.forecasts.each do |forecast|
        if match.result_home.present? && match.result_away.present?
          if match.result_home > match.result_away && forecast.outcome == "1"
            forecast.update(points_win: match.points_home)
          elsif match.result_home < match.result_away && forecast.outcome == "2"
            forecast.update(points_win: match.points_away)
          elsif match.result_home > match.result_away && forecast.outcome == "2"
            forecast.update(points_lose: match.negative_points_away)
          elsif match.result_home < match.result_away && forecast.outcome == "1"
            forecast.update(points_lose: match.negative_points_home)
          end
        end
      end
    end
  end
end
