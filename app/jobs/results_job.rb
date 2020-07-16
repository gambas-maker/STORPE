class ResultsJob < ApplicationJob
  queue_as :default

  def perform
    puts "Let's get the results"
    @matches = Match.where(event_stamp: Date.today.to_s)
    @matches.each do |game|
      SportOdd.get_results_for_match(game)
    end
  end
  puts "All the results are gathered"
end
