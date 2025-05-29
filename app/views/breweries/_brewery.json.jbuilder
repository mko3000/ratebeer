json.extract! brewery, :id, :name, :year, :active
json.beers brewery.beers.pluck(:name)
