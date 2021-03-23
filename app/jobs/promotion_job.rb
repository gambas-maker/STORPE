class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    Season.create(id: Season.last.id + 1, start_date: Date.today.to_s, end_date: (Date.today + 6).to_s)
    puts "New season is ready"

    # Montée en Semi-Pro
    @championshipama.each do |championshipama|
      ranking = {}
      championshipama.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking[hash] = hash.number_of_points }
      if ranking.count > 8
        ranking.sort_by { |k, v| v }.reverse.last(8).each { |k, v| puts k.update(championship_id: 4, season_id: Season.last.id - 2, number_of_points: 0) }
      else
        ranking.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: 4, season_id: Season.last.id - 2, number_of_points: 0) }
      end
    end
    PromotionldcJob.perform_now
  end
end
