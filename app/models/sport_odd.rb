require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class SportOdd
  BASE_URL = "https://api-football-v1.p.rapidapi.com/v2/"
  LEAGUE_IDS = [754, 1, 524, 3, 4]

  def self.all_matches_for_week
    LEAGUE_IDS.each do |league_id|
      matches_for_week(league_id)
    end
  end

  def self.matches_for_week(league_id)
    7.times do |index|
      matches_for_day(league_id, Date.today + index)
    end
  end

  def self.matches_for_day(league_id, date)
    end_point = URI("#{BASE_URL}fixtures/league/#{league_id}/#{date}")

    matches = call_api(end_point)["api"]["fixtures"]
    matches.each do |match|
      new_match = Match.create(
        team_home: match["homeTeam"]["team_name"],
        team_home_logo_url: match["homeTeam"]["logo"],
        team_away: match["awayTeam"]["team_name"],
        team_away_logo_url: match["awayTeam"]["logo"],
        fixture_id: match["fixture_id"],
        country: match["league"]["country"],
        league: match["league"]["name"],
        kick_off: match["event_date"]
      )
      get_odds_for_match(new_match)
      get_results_for_match(new_match)
    end
  end

  def self.get_odd(match_odds, type)
    odd_hash = match_odds.find do |bet_hash|
      bet_hash["value"] == type
    end
    odd_hash["odd"]
  end

  def self.get_odds_for_match(game)
    end_point = URI("#{BASE_URL}odds/fixture/#{game.fixture_id}")
    match_odds = call_api(end_point)["api"]["odds"][0]["bookmakers"][0]["bets"][0]["values"]
    game.update(
      points_home: get_odd(match_odds, "Home").to_i * 10,
      points_draw: get_odd(match_odds, "Draw").to_i * 10,
      points_away: get_odd(match_odds, "Away").to_i * 10
    )
  end

  def self.get_results_for_match(game)
    end_point = URI("#{BASE_URL}predictions/#{game.fixture_id}")
    match_results = call_api(end_point)["api"]["predictions"][0]
      game.update(
        result: match_results["match_winner"][1]
      )
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
