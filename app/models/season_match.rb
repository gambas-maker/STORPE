class SeasonMatch < ApplicationRecord
  belongs_to :match
  belongs_to :season
end
