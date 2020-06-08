class PlayerSeason < ApplicationRecord
  belongs_to :user, :seasons
  has_many :forecasts
end
