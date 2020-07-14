class Championship < ApplicationRecord
  belongs_to :season
  has_many :player_seasons
end
