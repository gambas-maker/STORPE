class PointsjoueurJob < ApplicationJob
  queue_as :default
  def perform
    @playerseasons = PlayerSeason.where(season_id: Season.last.id)
    @forecasts = Forecast.where(season_id: Season.last.id)
    @playerseasons.each do |playerseason|
      playerseason.forecasts.each do |forecast|
        if forecast.points_win.present? || forecast.points_lose.present?
          if forecast.points_win.present?
            points = []
            points << forecast.points_win
          else forecast.points_lose.present?
            points = []
            points << forecast.points_lose
          end
          playerseason.update(number_of_points: points.sum)
      else
      end
      end
    end
  end
end






# def perform(user_id)
# @user = User.find(user_id)
#     @playerseason = PlayerSeason.where(user_id: @user.id)
#     puts @playerseason
#     @forecasts = Forecast.where(player_season_id: @playerseason)
#     puts @forecasts
#     points = []
#     @forecasts.each do |forecast|
#       if forecast.points_win.present? || forecast.points_lose.present?
#         if forecast.points_win.present?
#           points << forecast.points_win
#         else forecast.points_lose.present?
#           points << forecast.points_lose
#         end
#         @playerseason.update(number_of_points: points.sum)
#       else
#       end
#     end
# end
