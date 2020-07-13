require 'sidekiq-scheduler'

class FetchapiJob < ApplicationJob
  sidekiq_options queue: :api_job

  def perform
    puts "I'm going to create games for the next two days"
    SportOdd.matches_for_four_days
    puts "I'm done with matches from Mon/Wed to Tue/Thu"
  end
end
