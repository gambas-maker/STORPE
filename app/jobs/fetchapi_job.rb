require 'sidekiq-scheduler'

class FetchapiJob < ApplicationJob
  def perform(scheduled_time)
    day_of_the_week = Time.at(scheduled_time).wday
    return unless (1 || 3).include?(day_of_the_week)

    puts "I'm going to create games for the next two days"
    SportOdd.matches_for_four_days
    puts "I'm done with matches from Mon/Wed to Tue/Thu"
  end
end
