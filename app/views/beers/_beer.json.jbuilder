json.extract! beer, :id, :name, :style
json.brewery do
  json.name beer.brewery.name
end
