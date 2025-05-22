class BeermappingApi
  def self.places_in(city)
    city = city.downcase

    Rails.cache.fetch(city, expires_in: 1.week) { get_places_in(city) }
  end

  def self.get_places_in(city)
    puts "Fetching data from Beermapping API for #{city}"
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{beer_url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.key
    "731955affc547174161dbd6f97b46538"
  end

  def self.beer_url_encode(city_name)
    # City names replace spaces with underscores. Dots arent allowed.
    ERB::Util.url_encode(city_name.gsub(/[. ]/, '_'))
  end
end
