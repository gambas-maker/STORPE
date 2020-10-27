class PromotionProJob < ApplicationJob
  queue_as :default

  def perform
    @championshippros = Championship.where(name: "Pro")
    @championshipsem = Championship.where(name: "Semi-pro")
    @playerseasons = PlayerSeason.all
    # Descente en division Semi-pro
    @championshippros.each do |championshippro|
      ranking3 = {}
      championshippro.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.each { |hash| ranking[hash] = hash.number_of_points }
      if ranking3.count >= 8
        array3 = []
        @championshipsem.each do |championshipsem|
          championshipsem.player_seasons.count <= 16 ? array3 << championshisem : array3
        end
        array3.empty? ? ranking.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: Championship.create!(name: "Semi-pro", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: array3.sample.id, season_id: Season.last.id) }
      else
        array3 = []
        @championshipsem.each do |championshipsem|
          championshipsem.player_seasons.count <= 16 ? array3 << championshisem : array3
        end
        array3.empty? ? ranking.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: Championship.create!(name: "Semi-pro", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: array3.sample.id, season_id: Season.last.id) }
      end
    end
    SeasonJob.perform_now
  end
end
