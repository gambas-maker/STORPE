class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    @season = Season.create!
    puts "New season is ready"
    @champ = Championship.where(name: "LDC")
    @championships = Championship.where(name: "CFA")
    @playerseasons = PlayerSeason.all
    @forecasts = Forecast.where(season_id: Season.last.id - 1)
    @championships.each do |championship|
      ranking = {}
      championship.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.exists? }.each { |hash| ranking[hash] = hash.number_of_points }
      puts ranking
      puts championship.player_seasons.count
      if ranking.count >= 8
        array = []
        @champ.each do |champion|
          champion.player_seasons.count <= 16 ? array << champion : array
        end
        array.empty? ? ranking.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: Championship.create!(name: "LDC", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: array.sample.id, season_id: Season.last.id) }
      else
        @champ.each do |champion|
          array = []
          champion.player_seasons.count <= 16 ? array << champion : array
        end
        array.empty? ? ranking.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: Championship.create!(name: "LDC", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: array.sample.id, season_id: Season.last.id) }
      end
    end
    PromotionldcJob.perform_now
  end
end
