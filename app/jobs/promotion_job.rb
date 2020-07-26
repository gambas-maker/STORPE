class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    @championships = Championship.all
    @playerseasons = PlayerSeason.all
    @forecasts = Forecast.where(season_id: Season.last.id)
    @championships.each do |championship|
      puts championship.player_seasons.sort
      # championship.player_seasons.each do |playerseason|
      #   if playerseason.forecasts.exists?
      #     championship.player_seasons.sort_by { |number| number }
      # puts championship.player_seasons
        # playerseason.sort_by
        # if playerseason.forecasts.exists?
        # else
        # puts "Dans les GLORRYYYY HOOOOOOOLE"
        end
      end
    end
  # end
# end
