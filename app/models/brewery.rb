class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true, uniqueness: true
  validates :year, numericality: { only_integer: true,
                                   greater_than: 1040 }
  validate :year_cannot_be_in_the_future

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  scope :best_rated, -> {
    Brewery.all.sort_by { |b| -b.average_rating }.take(3)
  }

  private

  def year_cannot_be_in_the_future
    return if year.blank?

    return unless year > Date.current.year

    errors.add(:year, "can't be in the future")
  end
end
