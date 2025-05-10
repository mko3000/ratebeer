require 'rails_helper'
require 'helpers'

describe "User" do
  include Helpers
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Nuuhkija", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Nuuhkija'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Nuuhkija", password: "höpölöpö")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Wrong username or password'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{ User.count }.by(1)
  end
end

describe "User page" do
  include Helpers

  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:brewery2) { FactoryBot.create :brewery, name: "Panimo2" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
  let!(:beer3) { FactoryBot.create :beer, name: "Kiisseli", style: "IPA", brewery: brewery2 }

  before :each do
    @user = FactoryBot.create :user
  end

  it "should show the username" do
    visit user_path(@user)

    expect(page).to have_content 'Nuuhkija'
  end

  it "should not have ratings before ratings have been created" do
    visit user_path(@user)

    expect(page).to have_content 'Has made 0 ratings'
  end

  it "should show the ratings of the user" do
    FactoryBot.create(:rating, user: @user, beer: beer1, score: 15)
    FactoryBot.create(:rating, user: @user, beer: beer2, score: 20)

    visit user_path(@user)
    expect(page).to have_content 'Has made 2 ratings'
    expect(page).to have_content 'iso 3 - 15'
    expect(page).to have_content 'Karhu - 20'
    expect(page).to have_content 'average of 17.5'
  end

  it "shold not show other users ratings" do
    other_user = FactoryBot.create(:user, username: "Hevostelija")
    FactoryBot.create(:rating, user: other_user, beer: beer1, score: 10)

    visit user_path(@user)
    expect(page).to have_content 'Has made 0 ratings'
    expect(page).not_to have_content 'Hevostelija'
    expect(page).not_to have_content 'iso 3 - 10'
  end

  it "should have a way to delete a for the user that is signed in" do
    sign_in(username: "Nuuhkija", password: "Foobar1")
    FactoryBot.create(:rating, user: @user, beer: beer1, score: 15)
    FactoryBot.create(:rating, user: @user, beer: beer2, score: 20)

    visit user_path(@user)

    expect(page).to have_content 'Has made 2 ratings'
    expect(page).to have_content 'iso 3 - 15'
    expect(page).to have_content 'Karhu - 20'

    expect{
      click_link(href: '/ratings/1')
    }.to change{ Beer.count }.by(0)

    expect(page).to have_content 'Rating deleted'
    expect(page).not_to have_content 'iso 3 - 15'
    expect(page).to have_content 'Karhu - 20'
  end

  it "should show the favorite style of the user" do
    FactoryBot.create(:rating, user: @user, beer: beer1, score: 15)
    FactoryBot.create(:rating, user: @user, beer: beer2, score: 20)
    FactoryBot.create(:rating, user: @user, beer: beer3, score: 10)

    visit user_path(@user)

    expect(page).to have_content 'Favorite style: Lager'
  end

  it "should show the favorite brewery of the user" do
    FactoryBot.create(:rating, user: @user, beer: beer1, score: 15)
    FactoryBot.create(:rating, user: @user, beer: beer2, score: 20)
    FactoryBot.create(:rating, user: @user, beer: beer3, score: 50)

    visit user_path(@user)

    expect(page).to have_content 'Favorite brewery: Panimo2'
  end
end
