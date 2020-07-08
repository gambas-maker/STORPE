class FetchapilastJob < ApplicationJob
  queue_as :default

  def perform
    puts "I'm going to create games for the last three days"
    SportOddEnd.matches_for_last_days
    puts "I'm done with matches from friday to Sunday"
  end
end
