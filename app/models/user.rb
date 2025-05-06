class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  PASSWORD_FORMAT = /\A
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
  /x

  validates :password, presence: true,
                       length: { minimum: 4 },
                       format: { with: PASSWORD_FORMAT },
                       confirmation: true
end
