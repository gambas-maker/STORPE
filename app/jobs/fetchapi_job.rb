class FetchapiJob < ApplicationJob
  queue_as :default

  def perform
    puts "I'm going to create the weekly games"
    SportOdd.all_matches_for_week
    puts "I'm done"
  end
end
