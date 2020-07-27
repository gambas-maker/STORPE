class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    @championships = Championship.all
    @playerseasons = PlayerSeason.all
    @forecasts = Forecast.where(season_id: Season.last.id)
    @championships.each do |championship|
      ranking = {}
      championship.player_seasons.each { |hash| ranking[hash] = hash.number_of_points }
      if championship.player_seasons.forecast.where(season_id: Season.last.id).count >= 8
        puts ranking.sort_by { |k, v| v }.reverse.first(4)
        puts ranking.sort_by { |k, v| k.forecasts.where(season_id: Season.last.id).exists? v }.reverse.last(4)
      else
        puts ranking.sort_by { |k, v| v }.reverse.first(2)
        puts ranking.sort_by { |k, v| k.forecasts.where(season_id: Season.last.id).exists? v }.reverse.last(2)
      end
    end
  end
end
