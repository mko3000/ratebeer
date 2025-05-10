require 'rails_helper'
require 'helpers'

describe "Rating" do
  include Helpers

  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Nuuhkija", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path


    select('iso 3 - Koff', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{ Rating.count }.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end

describe "Ratings page" do
  include Helpers

  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Nuuhkija", password: "Foobar1")
  end

  it "should not have any before ratings created" do
    visit ratings_path

    expect(page).to have_content 'List of ratings'
    expect(page).to have_content 'Number of ratings: 0'
  end

  it "should show the rating in the list" do
    visit new_rating_path

    select('iso 3 - Koff', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    click_button "Create Rating"

    visit ratings_path

    expect(page).to have_content 'List of ratings'
    expect(page).to have_content 'Number of ratings: 1'
    expect(page).to have_content 'iso 3 15 Nuuhkija'
  end
end
