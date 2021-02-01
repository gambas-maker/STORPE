class PromotionChampionJob < ApplicationJob
  queue_as :default

  def perform
    @championshippros = Championship.where(name: "Pro")
    @championshipchams = Championship.where(name: "Champion")
    # Descente en Pro
    @championshipchams.each do |championshipcham|
      ranking4 = {}
      championshipcham.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.each { |hash| ranking4[hash] = hash.number_of_points }
      if ranking4.count >= 8
        array4 = []
        @championshippros.each do |championshippro|
          championshippro.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.count <= 16 ? array4 << championshipsem : array4
        end
        if array4.empty?
          Championship.create(name: "Pro", season_id: Season.last.id)
          array4 << Championship.last
          ranking4.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: Championship.where(name: "Pro").last.id) }
        else
          ranking4.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: array4.sample.id, season_id: Season.last.id) }
        end
      else
        array4 = []
        @championshippros.each do |championshippro|
          championshippro.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.count <= 16 ? array4 << championshipsem : array4
        end
        if array4.empty?
          Championship.create(name: "Pro", season_id: Season.last.id)
          array4 << Championship.last
          ranking4.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: Championship.where(name: "Champion").last.id) }
        else
          ranking4.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: array4.sample.id, season_id: Season.last.id) }
        end
      end
    end
    SeasonJob.perform_now
  end
end
