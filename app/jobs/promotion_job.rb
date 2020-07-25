class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    @championships = Championship.all
    @playerseasons = PlayerSeason.all
    @forecasts = Forecast.where(season_id: Season.last.id)
    @championships.each do |championship|
      championship.player_seasons.each do |playerseason|
        if playerseason.forecasts.exists?
          puts playerseason.championship
        else
          # puts "Dans les GLORRYYYY HOOOOOOOLE"
        end
      end
    end
  end
end
