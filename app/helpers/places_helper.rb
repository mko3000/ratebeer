# app/helpers/places_helper.rb
module PlacesHelper
  def render_place_cell(place, field)
    if field.to_sym == :name
      link_to place.name, place_path(place.id)
    else
      place.public_send(field)
    end
  end
end
