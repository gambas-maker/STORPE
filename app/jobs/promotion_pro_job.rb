 class PromotionProJob < ApplicationJob
  queue_as :default

  def perform
    @championshippros = Championship.where(name: "Pro")
    rankingdescsemi = {}
    rankingmontchamp = {}
    # Descente en division Semi-pro
    @championshippros.each do |championshippro|
      ranking3 = {}
      championshippro.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking3[hash] = hash.number_of_points }
      if ranking3.count > 8
        ranking3.sort_by { |k, v| v }.reverse.last(4).each { |hash| rankingdescsemi[hash] = hash.championship_id }
      else
        ranking3.sort_by { |k, v| v }.reverse.last(2).each { |hash| rankingdescsemi[hash] = hash.championship_id }
      end
    end
    # Montée en division Champion
      @championshippros.each do |championshippro|
        ranking5 = {}
        championshippro.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking5[hash] = hash.number_of_points }
        if ranking5.count > 8
          ranking5.sort_by { |k, v| v }.reverse.first(4).each { |hash| rankingmontchamp[hash] = hash.championship_id }
        else
          ranking5.sort_by { |k, v| v }.reverse.first(2).each { |hash| rankingmontchamp[hash] = hash.championship_id }
        end
      end
    #PromotionChampionJob.perform_now
  end
end
