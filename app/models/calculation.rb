class Calculation < ApplicationRecord

  def self.calculate_points
    @matches = Match.where(season_id: Season.last.id)
    @forecasts = Forecast.where(season_id:Season.last.id)

    @matches.each do |match|
      match.forecasts.each do |forecast|
        if forecast.outcome == match.result
          if outcome == "1"
            forecast.points_win

          end
        else
        end
    end
  end
end
