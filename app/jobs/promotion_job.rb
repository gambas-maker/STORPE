class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    @championships = Championship.all
    @playerseasons = #ceux qui jouent, comment on les sélectionne ?
    @championships.each do |championship|

    end
  end
end
