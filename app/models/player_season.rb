class PlayerSeason < ApplicationRecord
  belongs_to :user
  belongs_to :season
  belongs_to :championship
  has_many :forecasts
  has_many :matches, through: :forecasts
end
