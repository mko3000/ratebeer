class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user
  validates :name, presence: true
  validates :style, presence: true

  scope :best_rated, -> {
    Beer.all.sort_by { |beer| -beer.average_rating }.take(3)
  }

  def to_s
    "#{name} - #{brewery.name}"
  end
end
