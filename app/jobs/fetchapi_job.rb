class FetchapiJob < ApplicationJob
  queue_as :default

  def perform
    puts "I'm gonna work"
    sleep 10
    puts "I'm done"
  end
end
