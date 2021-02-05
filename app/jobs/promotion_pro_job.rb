class PromotionProJob < ApplicationJob
  queue_as :default

  def perform
    @championshippros = Championship.where(name: "Pro")
    @championshipsem = Championship.where(name: "Semi-pro")
    @championshipchams = Championship.where(name: "Champion")
    # Descente en division Semi-pro
    @championshippros.each do |championshippro|
      ranking3 = {}
      championshippro.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking3[hash] = hash.number_of_points }
      if ranking3.count >= 8
        array3 = []
        @championshipsem.each do |championshipsem|
          array3 << championshipsem
        end
        ranking3.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: array3.first.id) }
      else
        array3 = []
        @championshipsem.each do |championshipsem|
          array3 << championshipsem
        end
        ranking3.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: array3.first.id) }
      end
    end
    # Montée en division Champion
      @championshippros.each do |championshippro|
        ranking5 = {}
        championshippro.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking5[hash] = hash.number_of_points }
        if ranking5.count >= 8
          array5 = []
          @championshipchams.each do |championshipcham|
            array5 << championshipcham
          end
          ranking5.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: array5.first.id) }
        else
          array5 = []
          @championshipchams.each do |championshipcham|
            array5 << championshipcham
          end
          ranking5.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: array5.first.id) }
        end
      end
    PromotionChampionJob.perform_now
  end
end
