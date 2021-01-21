class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    Season.create(id: Season.last.id + 1, start_date: Date.today.to_s, end_date: (Date.today + 7).to_s)
    puts "New season is ready"
    @champ = Championship.where(name: "Semi-pro")
    @championships = Championship.where(name: "Amateur")
    @playerseasons = PlayerSeason.all
    @championships.each do |championship|
      ranking = {}
      championship.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.each { |hash| ranking[hash] = hash.number_of_points }
      puts ranking
      if ranking.count >= 8
        array = []
        @champ.each do |champion|
          champion.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.count <= 16 ? array << champion : array
        end
        if array.empty?
          Championship.create!(name: "Semi-pro", season_id: Season.last.id)
          array << Championship.last
          ranking.sort_by { |k, v| v }.reverse.first(6).each { |k, v| puts k.update(championship_id: Championship.where(name: "Semi-pro").last.id)}
        else
          ranking.sort_by { |k, v| v }.reverse.first(6).each { |k, v| puts k.update(championship_id: array.sample.id, season_id: Season.last.id)}
        end
      else
        array = []
        @champ.each do |champion|
          champion.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.count <= 16 ? array << champion : array
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
