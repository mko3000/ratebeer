require 'rails_helper'

describe "Places" do
  before do
    allow(BeerweatherApi).to receive(:weather_in) do |city|
      {
        city:     city,
        desc:     "sunny",
        temp:     "20",
        wind:     "5",
        wind_dir: "N",
        icon:     "https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"
      }
    end
  end

  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [
        Place.new(name: "Oljenkorsi", id: 1)
      ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end
  it "if multiple is returned by the API, all of them are shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("vallilla").and_return(
      [
        Place.new(name: "Paavali", id: 1),
        Place.new(name: "Magneetti", id: 2),
        Place.new(name: "Sture Jazz Bar", id: 3)
      ]
    )

    visit places_path
    fill_in('city', with: 'vallilla')
    click_button "Search"

    expect(page).to have_content "Paavali"
    expect(page).to have_content "Magneetti"
    expect(page).to have_content "Sture Jazz Bar"
  end
  it "if no places are returned by the API, a message is shown" do
    allow(BeermappingApi).to receive(:places_in).with("koskela").and_return(
      []
    )

    visit places_path
    fill_in('city', with: 'koskela')
    click_button "Search"

    expect(page).to have_content "No locations in koskela"
  end
end
