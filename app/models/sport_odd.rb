require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class SportOdd
  BASE_URL = "https://api-football-v1.p.rapidapi.com/v2/"
  LEAGUE_IDS = [1, 524, 3, 4, 754]
  LEAGUE_IDS.each do |league_id|
    def self.matches_for_week(league_id)
        7.times do |index|
          matches_for_day(league_id, Date.today + index)
        end
    end
  end

  def self.matches_for_day(league_id, date)
    end_point = URI("#{BASE_URL}fixtures/league/#{league_id}/#{date}")
    response = call_api(end_point)
    if response["results"].to_i.positive?
      matches = call_api(end_point)["api"]["fixtures"]
      matches.each do |match|
        Match.create(team_home: match["homeTeam"]["team_name"], team_home_logo_url: match["homeTeam"]["logo"], team_away: match["awayTeam"]["team_name"], team_away_logo_url: match["awayTeam"]["logo"])
      end
    end
  end

  def self.all_matches_for_week
    LEAGUE_IDS.each do |league_id|
      matches_for_week(league_id)
    end
  end

  def self.get_odds_for_match(game)
    end_point = URI("#{BASE_URL}v2/odds/fixture/#{game.fixture_id}")
    matches = call_api(end_point)["api"]["odds"][0]["bookmakers"][0]["bets"][0]["values"][0]["odd"].to_i
    matches.each do |match|
      Match.create(points_home: match, points_draw: match, points_away: match)
    end
  end

  def self.call_api(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = '66ffc34423msh0c2c25d40ae94fbp153beajsn6c4930448075'

    response = http.request(request)
    JSON.parse(response.body)
  end
end
