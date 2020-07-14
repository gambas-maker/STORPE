class Season < ApplicationRecord
  has_many :player_seasons
  has_many :season_matchs
  has_many :championships
end
