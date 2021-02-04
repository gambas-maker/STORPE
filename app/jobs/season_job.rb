require 'sidekiq-scheduler'

class SeasonJob < ApplicationJob
  def perform
    Championship.update_all(season_id: Season.last.id)
    @playerseasons = PlayerSeason.where(season_id: Season.last.id - 1)
    @playerseasons.each do |playerseason|
      playerseason.update(number_of_points: 0)
    end
    puts "All player seasons are updated same for Championship"
  end
end
