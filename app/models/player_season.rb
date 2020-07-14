class PlayerSeason < ApplicationRecord
  belongs_to :user
  belongs_to :season
  has_many :forecasts
  has_many :matches, through: :forecasts
end
