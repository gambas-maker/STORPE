 class PromotionProJob < ApplicationJob
  queue_as :default

  def perform
    @championshippros = Championship.where(name: "Pro")
    # Descente en division Semi-pro
    @championshippros.each do |championshippro|
      ranking3 = {}
      championshippro.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking3[hash] = hash.number_of_points }
      if ranking3.count > 8
        ranking3.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: 4, season_id: Season.last.id - 2, number_of_points: 0) }
      else
        rranking3.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: 4, season_id: Season.last.id - 2, number_of_points: 0) }
      end
    end
    # Montée en division Champion
      @championshippros.each do |championshippro|
        ranking5 = {}
        championshippro.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking5[hash] = hash.number_of_points }
        if ranking5.count > 8
          ranking5.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: 255, season_id: Season.last.id - 2, number_of_points: 0) }
        else
          ranking5.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: 255, season_id: Season.last.id - 2, number_of_points: 0) }
        end
      end
    PromotionChampionJob.perform_now
  end
end
