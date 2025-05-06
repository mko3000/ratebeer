# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

u1 = User.create username: "Batman", password: "Batman1", password_confirmation: "Batman1"
u2 = User.create username: "Joker", password: "Joker1", password_confirmation: "Joker1"
u3 = User.create username: "Superman", password: "Superman1", password_confirmation: "Superman1"

b1 = Brewery.create name: "Koff", year: 1897
b2 = Brewery.create name: "Malmgard", year: 2001
b3 = Brewery.create name: "Weihenstephaner", year: 1040

beer1 = b1.beers.create name: "Iso 3", style: "Lager"
beer2 = b1.beers.create name: "Karhu", style: "Lager"
beer3 = b1.beers.create name: "Tuplahumala", style: "Lager"
beer4 = b2.beers.create name: "Huvila Pale Ale", style: "Pale Ale"
beer5 = b2.beers.create name: "X Porter", style: "Porter"
beer6 = b3.beers.create name: "Hefeweizen", style: "Weizen"
beer7 = b3.beers.create name: "Helles", style: "Lager"

beer1.ratings.create score: rand(1..50), user: u1
beer1.ratings.create score: rand(1..50), user: u2
beer2.ratings.create score: rand(1..50), user: u1
beer2.ratings.create score: rand(1..50), user: u2
beer3.ratings.create score: rand(1..50), user: u1
beer4.ratings.create score: rand(1..50), user: u1
beer4.ratings.create score: rand(1..50), user: u2
beer5.ratings.create score: rand(1..50), user: u1
beer7.ratings.create score: rand(1..50), user: u2
beer7.ratings.create score: rand(1..50), user: u1

club1 = BeerClub.create name: "Nuuhkijat", city: "Viljakkala", founded: 2012
