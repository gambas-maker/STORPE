class PromotionProJob < ApplicationJob
  queue_as :default

  def perform
    @championshippros = Championship.where(name: "Pro")
    @championshipsem = Championship.where(name: "Semi-pro")
    @championshipchams = Championship.where(name: "Champion")
    # Descente en division Semi-pro
    @championshippros.each do |championshippro|
      ranking3 = {}
      championshippro.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.each { |hash| ranking3[hash] = hash.number_of_points }
      if ranking3.count >= 8
        array3 = []
        @championshipsem.each do |championshipsem|
          championshipsem.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.count <= 16 ? array3 << championshipsem : array3
        end
        if array3.empty?
          Championship.create(name: "Semi-pro", season_id: Season.last.id)
          array3 << Championship.last
          ranking3.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: Championship.where(name: "Semi-pro").last.id) }
        else
          ranking3.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: array3.sample.id, season_id: Season.last.id) }
        end
      else
        array3 = []
        @championshipsem.each do |championshipsem|
          championshipsem.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.count <= 16 ? array3 << championshipsem : array3
        end
        if array3.empty?
          Championship.create(name: "Semi-pro", season_id: Season.last.id)
          array3 << Championship.last
          ranking3.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: Championship.where(name: "Semi-pro").last.id) }
        else
          ranking3.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: array3.sample.id, season_id: Season.last.id) }
        end
      end
    end
    # Montée en division Champion
      @championshippros.each do |championshippro|
        ranking5 = {}
        championshippro.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.each { |hash| ranking5[hash] = hash.number_of_points }
        if ranking5.count >= 8
          array5 = []
          @championshipchams.each do |championshipcham|
            championshipcham.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.count <= 16 ? array5 << championshippro : array5
          end
          if array5.empty?
            Championship.create(name: "Champion", season_id: Season.last.id)
            array5 << Championship.last
            ranking5.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: Championship.where(name: "Champion").last.id)}
          else
            ranking5.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: array5.sample.id, season_id: Season.last.id) }
          end
        else
          array5 = []
          @championshipchams.each do |championshipcham|
            championshipcham.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.count <= 16 ? array5 << championshippro : array5
          end
          if array5.empty?
            Championship.create(name: "Champion", season_id: Season.last.id)
            array5 << Championship.last
            ranking5.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: Championship.where(name: "Champion").last.id)}
          else
            ranking5.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: array5.sample.id, season_id: Season.last.id) }
          end
        end
      end
    PromotionChampionJob.perform_now
  end
end
