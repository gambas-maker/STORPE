class ResultsJob < ApplicationJob
  queue_as :default

  def perform
    puts "Let's get the football results"
    @matches = Match.where(event_stamp: Date.yesterday.to_s, sport: "football")
    @matches.each do |game|
      SportOdd.get_results_for_match(game)
    end
    CalculatepointsJob.perform_now
    RecalcpointsJob.perform_now
  end
end
