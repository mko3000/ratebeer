# require 'rails_helper'

# describe "Beerlist page" do
#   before :all do
#     # Webdrivers::Chromedriver.required_version = "114.0.5735.90"
#     # Webdrivers::Chromedriver.required_version = "137.0.7151.55"

    
#     Capybara.register_driver :chrome do |app|
#       Capybara::Selenium::Driver.new(app, browser: :chrome, :driver_path => '/usr/local/bin/chromedriver')
#     end

#     Capybara.javascript_driver = :chrome

#     WebMock.allow_net_connect!
#   end

#   before :each do
#     @brewery1 = FactoryBot.create(:brewery, name: "Koff")
#     @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
#     @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
#     @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style: "Lager")
#     @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery: @brewery2, style: "Rauchbier")
#     @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: "Weizen")
#   end

#   it "shows one known beer", js: true do
#     visit beerlist_path
#     expect(page).to have_content "Nikolai"
#   end
# end
