class PlayerSeason < ApplicationRecord
  belongs_to :user
  belongs_to :season
  has_many :forecasts
end
