class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    Season.create(id: Season.last.id + 1, start_date: Date.today.to_s, end_date: (Date.today + 6).to_s)
    puts "New season is ready"
    @champ = Championship.where(name: "Semi-pro")
    @championships = Championship.where(name: "Amateur")
    @championships.each do |championship|
      ranking = {}
      championship.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking[hash] = hash.number_of_points }
      puts ranking
      if ranking.count >= 8
        array = []
        @champ.each do |champion|
          array << champion
        end
        ranking.sort_by { |k, v| v }.reverse.first(8).each { |k, v| puts k.update(championship_id: array.first.id)}
      else
        array = []
        @champ.each do |champion|
          array << champion
        end
        ranking.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: array.first.id)}
      end
    end
    PromotionldcJob.perform_now
  end
end
