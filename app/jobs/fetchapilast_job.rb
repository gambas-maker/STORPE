require 'sidekiq-scheduler'

class FetchapilastJob < ApplicationJob
  sidekiq_options queue: :api_job

  def perform
    puts "I'm going to create games for the last three days"
    SportOddEnd.matches_for_last_days
    puts "I'm done with matches from friday to Sunday"
  end
end
