class RecalcpointsJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |u|
      PointsjoueurJob.perform_now(u.id)
    end
  end
end
