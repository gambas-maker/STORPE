class UpdatebasketpointsJob < ApplicationJob
  queue_as :default

  def perform
    @matches = Match.where(sport: "basketball", points_home: nil)
    @matches.each do |match|
      BasketballTomorrow.get_odds_for_match(match)
    end
  end
end
