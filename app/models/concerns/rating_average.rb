module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings.average(:score).to_f || 0.0
  end
end
