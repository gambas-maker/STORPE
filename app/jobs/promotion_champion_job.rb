class PromotionChampionJob < ApplicationJob
  queue_as :default

  def perform
    @championshippros = Championship.where(name: "Pro")
    @championshipchams = Championship.where(name: "Champion")
    # Descente en Pro
    @championshipchams.each do |championshipcham|
      ranking4 = {}
      championshipcham.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking4[hash] = hash.number_of_points }
      if ranking4.count >= 8
        array4 = []
        @championshippros.each do |championshippro|
          array4 << championshippro
        end
        ranking4.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: array4.first.id) }
      else
        array4 = []
        @championshippros.each do |championshippro|
          array4 << championshippro
        end
        ranking4.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: array4.first.id) }
      end
    end
    SeasonJob.perform_now
  end
end
