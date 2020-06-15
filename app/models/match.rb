class Match < ApplicationRecord
  has_many :forecasts
  has_many :season_matchs

  # after_commit :async_update # Run on create & update

  private

  # def async_update
  #   FetchapiJob.perform_at(2.hours.from_now, 'mike', 1)
  # end
end
