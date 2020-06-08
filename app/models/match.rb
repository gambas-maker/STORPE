class Match < ApplicationRecord
  has_many :forecasts
  has_many :season_matchs
end
