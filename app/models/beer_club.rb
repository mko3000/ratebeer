class BeerClub < ApplicationRecord
  include CurYearCheck

  has_many :memberships

  validates :name, presence: true
  validates :founded, numericality: { only_integer: true,
                                      greater_than: -6000 }
  validate :founded_cannot_be_in_the_future

  def to_s
    name.to_s
  end

  private

  def founded_cannot_be_in_the_future
    return if founded.blank?

    return unless founded > Date.current.year

    errors.add(:founded, "can't be in the future")
  end
end
