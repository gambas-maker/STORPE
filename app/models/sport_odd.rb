require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class SportOdd
  BASE_URL = "https://api-football-v1.p.rapidapi.com/v2/"
  LEAGUE_ID = { fr: 1, gb: 2, it: 3, es: 4, de: 5 }
  def self.matches_for_week
    end_point = "#{BASE_URL}fixtures/league/#{LEAGUE_ID}/#{date}?timezone=Europe%252FLondon"
    matches = call_api(end_point)["api"]["fixtures"]
    matches.each do |match|
      Match.create(fixture_id: )
    end
  end

  def self.get_odds_for_match(game)
    end_point = "#{BASE_URL}v2/odds/fixture/%7B#{game.fixture_id}%7D"
  end

  private

  def call_api(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = '66ffc34423msh0c2c25d40ae94fbp153beajsn6c4930448075'

    response = http.request(request)
    bon = JSON.parse(response.body)
  end
end
