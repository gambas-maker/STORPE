class PromotionChampionJob < ApplicationJob
  queue_as :default

  def perform
    @championshipchams = Championship.where(name: "Champion")
    # Descente en Pro
    @championshipchams.each do |championshipcham|
      ranking4 = {}
      championshipcham.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking4[hash] = hash.number_of_points }
      if ranking4.count >= 8
        ranking4.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: 61) }
      else
        ranking4.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: 61) }
      end
    end
    SeasonJob.perform_now
  end
end
