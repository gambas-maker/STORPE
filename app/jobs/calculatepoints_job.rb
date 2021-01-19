class CalculatepointsJob < ApplicationJob
  queue_as :default
  def perform
    @matches = Match.where(sport: "football", event_stamp: Date.today.to_s)
    @forecasts = Forecast.where(season_id: Season.last.id, confirmed: true)
    @matches.each do |match|
      match.forecasts.each do |forecast|
        if match.result.present?
          if match.result[0].to_i > match.result[2].to_i && forecast.outcome == "1"
            forecast.update(points_win: match.points_home)
          elsif match.result[0].to_i == match.result[2].to_i && forecast.outcome == "NULL"
            forecast.update(points_win: match.points_draw)
          elsif match.result[0].to_i < match.result[2].to_i && forecast.outcome == "2"
            forecast.update(points_win: match.points_away)
          elsif match.result[0].to_i > match.result[2].to_i && forecast.outcome == "NULL"
            forecast.update(points_lose: match.negative_points_draw)
          elsif match.result[0].to_i < match.result[2].to_i && forecast.outcome == "NULL"
            forecast.update(points_lose: match.negative_points_draw)
          elsif match.result[0].to_i > match.result[2].to_i && forecast.outcome == "2"
            forecast.update(points_lose: match.negative_points_away)
          elsif match.result[0].to_i == match.result[2].to_i && forecast.outcome == "2"
            forecast.update(points_lose: match.negative_points_away)
          elsif match.result[0].to_i == match.result[2].to_i && forecast.outcome == "1"
            forecast.update(points_lose: match.negative_points_home)
          elsif match.result[0].to_i < match.result[2].to_i && forecast.outcome == "1"
            forecast.update(points_lose: match.negative_points_home)
          elsif forecast.outcome == "7" && match.result[0].to_i > 0 && match.result[2].to_i > 0
            forecast.update(points_win: match.goal_two_teams_yes)
          elsif forecast.outcome == "7" && match.result[0].to_i < 1 || match.result[2].to_i < 1
            forecast.update(points_lose: match.negative_goal_two_teams_yes)
          elsif forecast.outcome == "8" && match.result[0].to_i > 0 && match.result[2].to_i > 0
            forecast.update(points_lose: match.negative_goal_two_teams_no)
          elsif forecast.outcome == "8" && match.result[0].to_i == 0 || match.result[2].to_i == 0
            forecast.update(points_win: match.goal_two_teams_no)
          elsif forecast.outcome == "9" && match.result[0].to_i + match.result[2].to_i > 2
            forecast.update(points_lose: match.negative_under25)
          elsif forecast.outcome == "9" && match.result[0].to_i + match.result[2].to_i < 3
            forecast.update(points_win: match.under_25)
          elsif forecast.outcome == "10" && match.result[0].to_i + match.result[2].to_i > 2
            forecast.update(points_win: match.over_25)
          elsif forecast.outcome == "10" && match.result[0].to_i + match.result[2].to_i < 3
            forecast.update(points_lose: match.negative_over25)
          end
        end
      end
    end
  end
end
