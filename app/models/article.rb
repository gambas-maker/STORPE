class Article < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :text, presence: true
end
