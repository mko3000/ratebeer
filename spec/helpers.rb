module Helpers

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def create_brewery(name, year)
    FactoryBot.create(:brewery, name: name, year: year)
  end
end