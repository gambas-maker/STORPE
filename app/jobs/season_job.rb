require 'sidekiq-scheduler'

class SeasonJob < ApplicationJob
  def perform
    Championship.update_all(season_id: Season.last.id)
    @playerseasons = PlayerSeason.where(season_id: Season.last.id - 1)
    @playerseasons.each do |playerseason|
      playerseason.update(number_of_points: 0)
    end
    puts "All player seasons are updated same for Championship"
    @championshipama = Championship.where(name: "Amateur")
    @championshipama.each do |championshipama|
      championshipama.player_seasons.update(championship_id: 11)
    end
    @championshipsemi = Championship.where(name: "Semi-pro")
    @championshipsemi.each do |championshipsemi|
      championshipsemi.player_seasons.update(championship_id: 4)
    end
    @championshippro = Championship.where(name: "Pro")
    @championshippro.each do |championshippro|
      championshippro.player_seasons.update(championship_id: 61)
    end
    @championshipchamp = Championship.where(name: "Champion")
    @championshipchamp.each do |championshipchamp|
      championshipchamp.player_seasons.update(championship_id: 255)
    end
  end
end
