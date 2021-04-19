class ResultsbaskettodayJob < ApplicationJob
  queue_as :default

  def perform
    puts "Let's get the basketball results"
    @matches = Match.where(event_stamp: "2021-04-14", sport: "basketball")
    @matches.each do |game|
      BasketballTomorrow.get_results_for_match(game)
    end
    puts "All the results are gathered"
    CalculatepointsbasketJob.perform_now
    RecalcpointsJob.perform_now
  end
end
