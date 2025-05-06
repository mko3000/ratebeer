module CurYearCheck
  extend ActiveSupport::Concern

  private

  def year_cannot_be_in_the_future(year)
    return if year.blank?

    return unless year > Date.current.year

    errors.add(:year, "can't be in the future")
  end
end
