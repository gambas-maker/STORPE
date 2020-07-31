class PointsjoueurJob < ApplicationJob
  queue_as :default
  def perform(user_id)
    @user = User.find(user_id)
    @playerseason = PlayerSeason.where(user_id: @user.id)
    @forecasts = Forecast.where(player_season_id: @playerseason)
    points = []
    @forecasts.each do |forecast|
      if forecast.points_win.present? || forecast.points_lose.present?
        if forecast.points_win.present?
          points << forecast.points_win
        else forecast.points_lose.present?
          points << forecast.points_lose
        end
        @playerseason.update(number_of_points: points.sum)
      else
      end
    end
  end
end
