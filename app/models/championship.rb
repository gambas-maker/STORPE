class Championship < ApplicationRecord
  belongs_to :season
  has_many :player_seasons
  has_many :users, through: :player_seasons
end
