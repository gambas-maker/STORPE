require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class SportOdd
  BASE_URL = "https://api-football-v1.p.rapidapi.com/v2/"
  LEAGUE_IDS = [525, 524, 775, 891, 754]
  # 525 = France, 524 = Angleterre, 775 = Espagne, 891 = Italie, 754 = Allemagne

  def self.matches_for_four_days
    LEAGUE_IDS.each do |league_id|
      matches_for_two_days(league_id)
    end
    points_home_negative_points
    points_draw_negative_points
    points_away_negative_points
  end

  def self.matches_for_two_days(league_id)
    2.times do |index|
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
        kick_off: DateTime.parse(match["event_date"])
      )
      get_odds_for_match(new_match)
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

  def self.points_home_negative_points
    @matches = Match.all
    @matches.each do |game|
      if game.points_home < 11
        game.update(negative_points_home: -15)
      elsif game.points_home >= 11 && game.points_home < 13
        game.update(negative_points_home: -11)
      elsif game.points_home >= 13 && game.points_home < 15
        game.update(negative_points_home: -10)
      elsif game.points_home >= 15 && game.points_home < 16
        game.update(negative_points_home: -9)
      elsif game.points_home >= 16 && game.points_home < 18
        game.update(negative_points_home: -8)
      elsif game.points_home >= 18 && game.points_home < 20
        game.update(negative_points_home: -7)
      elsif game.points_home >= 20 && game.points_home < 22.5
        game.update(negative_points_home: -7)
      elsif game.points_home >= 22.5 && game.points_home < 25
        game.update(negative_points_home: -6)
      elsif game.points_home > 25
        game.update(negative_points_home: -5)
      end
    end
  end

  def self.points_draw_negative_points
    @matches = Match.all
    @matches.each do |game|
      if game.points_draw < 11
        game.update(negative_points_draw: -15)
      elsif game.points_draw >= 11 && game.points_draw < 13
        game.update(negative_points_draw: -11)
      elsif game.points_draw >= 13 && game.points_draw < 15
        game.update(negative_points_draw: -10)
      elsif game.points_draw >= 15 && game.points_draw < 16
        game.update(negative_points_draw: -9)
      elsif game.points_draw >= 16 && game.points_draw < 18
        game.update(negative_points_draw: -8)
      elsif game.points_draw >= 18 && game.points_draw < 20
        game.update(negative_points_draw: -7)
      elsif game.points_draw >= 20 && game.points_draw < 22.5
        game.update(negative_points_draw: -7)
      elsif game.points_draw >= 22.5 && game.points_draw < 25
        game.update(negative_points_draw: -6)
      elsif game.points_draw > 25
        game.update(negative_points_draw: -5)
      end
    end
  end

  def self.points_away_negative_points
    @matches = Match.all
    @matches.each do |game|
      if game.points_away < 11
        game.update(negative_points_away: -15)
      elsif game.points_away >= 11 && game.points_away < 13
        game.update(negative_points_away: -11)
      elsif game.points_away >= 13 && game.points_away < 15
        game.update(negative_points_away: -10)
      elsif game.points_away >= 15 && game.points_away < 16
        game.update(negative_points_away: -9)
      elsif game.points_away >= 16 && game.points_away < 18
        game.update(negative_points_away: -8)
      elsif game.points_away >= 18 && game.points_away < 20
        game.update(negative_points_away: -7)
      elsif game.points_away >= 20 && game.points_away < 22.5
        game.update(negative_points_away: -7)
      elsif game.points_away >= 22.5 && game.points_away < 25
        game.update(negative_points_away: -6)
      elsif game.points_away > 25
        game.update(negative_points_away: -5)
      end
    end
  end

  def self.sort
    date_array = []
    @matches = Match.all
    @matches.each do |m|
      date_clean = m.kick_off.to_i
      date_array << date_clean
    end
    date_array.sort
  end
end

class SportOddEnd
  BASE_URL = "https://api-football-v1.p.rapidapi.com/v2/"
  LEAGUE_IDS = [525, 524, 775, 891, 754]
  # 525 = France, 524 = Angleterre, 775 = Espagne, 891 = Italie, 754 = Allemagne

  def self.matches_for_last_days
    LEAGUE_IDS.each do |league_id|
      matches_for_three_days(league_id)
    end
    points_home_negative_points
    points_draw_negative_points
    points_away_negative_points
  end

  def self.matches_for_three_days(league_id)
    3.times do |index|
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
        kick_off: DateTime.parse(match["event_date"])
      )
      get_odds_for_match(new_match)
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

  def self.points_home_negative_points
    @matches = Match.all
    @matches.each do |game|
      if game.points_home < 11
        game.update(negative_points_home: -15)
      elsif game.points_home >= 11 && game.points_home < 13
        game.update(negative_points_home: -11)
      elsif game.points_home >= 13 && game.points_home < 15
        game.update(negative_points_home: -10)
      elsif game.points_home >= 15 && game.points_home < 16
        game.update(negative_points_home: -9)
      elsif game.points_home >= 16 && game.points_home < 18
        game.update(negative_points_home: -8)
      elsif game.points_home >= 18 && game.points_home < 20
        game.update(negative_points_home: -7)
      elsif game.points_home >= 20 && game.points_home < 22.5
        game.update(negative_points_home: -7)
      elsif game.points_home >= 22.5 && game.points_home < 25
        game.update(negative_points_home: -6)
      elsif game.points_home > 25
        game.update(negative_points_home: -5)
      end
    end
  end

  def self.points_draw_negative_points
    @matches = Match.all
    @matches.each do |game|
      if game.points_draw < 11
        game.update(negative_points_draw: -15)
      elsif game.points_draw >= 11 && game.points_draw < 13
        game.update(negative_points_draw: -11)
      elsif game.points_draw >= 13 && game.points_draw < 15
        game.update(negative_points_draw: -10)
      elsif game.points_draw >= 15 && game.points_draw < 16
        game.update(negative_points_draw: -9)
      elsif game.points_draw >= 16 && game.points_draw < 18
        game.update(negative_points_draw: -8)
      elsif game.points_draw >= 18 && game.points_draw < 20
        game.update(negative_points_draw: -7)
      elsif game.points_draw >= 20 && game.points_draw < 22.5
        game.update(negative_points_draw: -7)
      elsif game.points_draw >= 22.5 && game.points_draw < 25
        game.update(negative_points_draw: -6)
      elsif game.points_draw > 25
        game.update(negative_points_draw: -5)
      end
    end
  end

  def self.points_away_negative_points
    @matches = Match.all
    @matches.each do |game|
      if game.points_away < 11
        game.update(negative_points_away: -15)
      elsif game.points_away >= 11 && game.points_away < 13
        game.update(negative_points_away: -11)
      elsif game.points_away >= 13 && game.points_away < 15
        game.update(negative_points_away: -10)
      elsif game.points_away >= 15 && game.points_away < 16
        game.update(negative_points_away: -9)
      elsif game.points_away >= 16 && game.points_away < 18
        game.update(negative_points_away: -8)
      elsif game.points_away >= 18 && game.points_away < 20
        game.update(negative_points_away: -7)
      elsif game.points_away >= 20 && game.points_away < 22.5
        game.update(negative_points_away: -7)
      elsif game.points_away >= 22.5 && game.points_away < 25
        game.update(negative_points_away: -6)
      elsif game.points_away > 25
        game.update(negative_points_away: -5)
      end
    end
  end

  def self.sort
    date_array = []
    @matches = Match.all
    @matches.each do |m|
      date_clean = m.kick_off.to_i
      date_array << date_clean
    end
    date_array.sort
  end
end
