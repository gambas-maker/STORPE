class FetchApiOneDayJob < ApplicationJob
  queue_as :default

  def perform
    puts "I'm going to check games for today"
    SportOddOneDay.matches_for_last_days
    puts "I'm done with matches for today"
  end
end
