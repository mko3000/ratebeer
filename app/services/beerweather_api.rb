class BeerweatherApi < ApplicationController
  def self.weather_in(city)
    city = ERB::Util.url_encode(city.gsub(/[. ]/, '_')).downcase
    get_weather_in(city)
  end

  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{city}"
    response = HTTParty.get(url)
    return nil unless response && response["location"] && response["current"]

    {
      city: response.dig("location", "name"),
      desc: response.dig("current", "weather_descriptions", 0)&.downcase,
      temp: response.dig("current", "temperature"),
      wind: response.dig("current", "wind_speed"),
      wind_dir: response.dig("current", "wind_dir"),
      icon: response.dig("current", "weather_icons", 0)
    }
  rescue StandardError
    nil
  end

  def self.key
    "2992ef47f1f5786264d6efdc9fd7a0cc"
  end
end
