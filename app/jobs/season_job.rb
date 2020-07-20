require 'sidekiq-scheduler'

class SeasonJob < ApplicationJob
  def perform
    puts "New season is coming!"
    @season = Season.create!
    puts "New is season is ready"
    PlayerSeason.update_all(season_id: @season.id)
    @playerseasons = PlayerSeason.where(season_id: Season.last.id)
    @playerseasons.each do |playerseason|
      playerseason.update(number_of_points: 0)
    end
    puts "All player seasons are updated"
  end
end
