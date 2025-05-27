class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy

  validates :username,
            uniqueness: true,
            length: { minimum: 3, maximum: 30 }

  PASSWORD_FORMAT = /\A
    (?=.*\d)           # must contain a digit
    (?=.*[a-z])        # must contain a lower-case letter
    (?=.*[A-Z])        # must contain an upper-case letter
    .{4,}              # at least 4 characters long
  \z/x

  validates :password,
            presence: true,
            format: { with: PASSWORD_FORMAT,
                      message: "must be ≥4 chars, include at least one lowercase letter, one uppercase letter, and one digit" },
            confirmation: true

  scope :top_raters, ->(n) {
    User.joins(:ratings)
        .group(:id)
        .order('COUNT(ratings.id) DESC')
        .limit(n)
  }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings
      .joins(:beer)
      .group("beers.style")
      .average(:score)
      .max_by { |_, avg| avg }
      &.first
  end

  def favorite_brewery
    return nil if ratings.empty?

    brewery_id = ratings
                 .joins(:beer)
                 .group("beers.brewery_id")
                 .average(:score)
                 .max_by { |_, avg| avg }
                 &.first
    Brewery.find(brewery_id) if brewery_id
  end
end
