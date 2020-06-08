class Forecast < ApplicationRecord
  belongs_to :player_season, :match
end
