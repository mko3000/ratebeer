require 'rails_helper'
require 'helpers'

describe "Beers page" do
  include Helpers
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff", year: 1896 }
  let!(:user) { FactoryBot.create :user }

  it "should not have any before been created" do
    visit beers_path
    expect(page).to have_content 'Beers'
    expect(page).to have_content 'Number of beers: 0'
  end

  it "should have an ability to create a new beer with valid beer name if uer signed in" do
    sign_in(username: "Nuuhkija", password: "Foobar1")
    visit new_beer_path

    fill_in('beer_name', with: 'Test beer')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button('Create Beer')
    }.to change{ Beer.count }.by(1)

    expect(page).to have_content 'Beer was successfully created'
  end

  it "should not show the create beer button if user not signed in" do
    visit beers_path
    expect(page).not_to have_content 'Create Beer'
  end

  it "should fail to create a new beer with invalid beer name" do
    sign_in(username: "Nuuhkija", password: "Foobar1")
    visit new_beer_path
    fill_in('beer_name', with: '')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button('Create Beer')
    }.to change{ Beer.count }.by(0)

    expect(page).to have_content 'error prohibited this beer from being saved'
  end
end
