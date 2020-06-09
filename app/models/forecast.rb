class Forecast < ApplicationRecord
  belongs_to :player_season
  belongs_to :match
end
