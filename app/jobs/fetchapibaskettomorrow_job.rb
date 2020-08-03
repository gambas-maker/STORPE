class FetchapibaskettomorrowJob < ApplicationJob
  queue_as :default

  def perform
    puts "I'm going to create games for tomorrow "
    BasketballTomorrow.match_for_two_days
    puts "I'm done with matches for tomorrow"
  end
end
