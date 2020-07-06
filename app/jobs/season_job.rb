require 'sidekiq-scheduler'

class SeasonJob < ApplicationJob
  queue_as :default
  include Sidekiq::Worker

  def perform
    puts "New season is coming!"
    @season = Season.create!
    puts "New is season is ready"
    PlayerSeason.update_all(season_id: @season.id)
    puts "All player seasons are updated"
  end
end
