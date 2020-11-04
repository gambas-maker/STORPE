class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    Season.create(id: Season.last.id + 1)
    puts "New season is ready"
    @champ = Championship.where(name: "Semi-pro")
    @championships = Championship.where(name: "Amateur")
    @playerseasons = PlayerSeason.all
    @forecasts = Forecast.where(season_id: Season.last.id - 1)
    @championships.each do |championship|
      ranking = {}
      championship.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.each { |hash| ranking[hash] = hash.number_of_points }
      if ranking.count >= 8
        array = []
        @champ.each do |champion|
          champion.player_seasons.count <= 16 ? array << champion : array
        end
        if array.empty?
          Championship.create!(name: "Semi-pro", season_id: Season.last.id)
          array << Championship.last
          ranking.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: Championship.where(name: "Semi-pro").last.id)}
        else
          ranking.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: array.sample.id, season_id: Season.last.id)}
        end
      else
        @champ.each do |champion|
          array = []
          champion.player_seasons.count <= 16 ? array << champion : array
        end
        if array.empty?
          Championship.create!(name: "Semi-pro", season_id: Season.last.id)
          array << Championship.last
          ranking.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: Championship.where(name: "Semi-pro").last.id)}
        else
          ranking.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: array.sample.id, season_id: Season.last.id)}
        end
      end
    end
    PromotionldcJob.perform_now
  end
end
