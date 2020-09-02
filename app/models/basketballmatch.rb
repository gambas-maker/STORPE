require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class Basketballmatch < ApplicationRecord
  BASE_URL = "https://v1.basketball.api-sports.io/"
  LEAGUE_ID = [12]
  # 12 = NBA

  def self.match_for_two_days
    LEAGUE_ID.each do |league_id|
      call_for_days(league_id)
    end
    points_home_negative_points
    points_away_negative_points
  end

  def self.call_for_days(league_id)
    1.times do
      matches_for_day(league_id, Date.today)
    end
  end

  def self.matches_for_day(league_id, date)
    end_point = URI("#{BASE_URL}games?league=#{league_id}&season=2019-2020&date=#{date}&timezone=Europe/Paris")
    matches = call_api(end_point)["response"]
    sport = "basketball"
    matches.each do |match|
      new_match = Match.create(
        team_home: match["teams"]["home"]["name"],
        team_home_logo_url: match["teams"]["home"]["logo"],
        team_away: match["teams"]["away"]["name"],
        team_away_logo_url: match["teams"]["away"]["logo"],
        sport: sport,
        fixture_id: match["id"],
        league: match["league"]["name"],
        event_stamp: DateTime.strptime(match["timestamp"].to_s, '%s').to_date,
        kick_off: DateTime.parse(match["date"])
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
    end_point = URI("#{BASE_URL}odds?league=12&season=2019-2020&game=#{game.fixture_id}")
    result = call_api(end_point)["results"]
    if result.zero?
    else
      match_odds = call_api(end_point)["response"][0]["bookmakers"][0]["bets"][0]["values"]
      if match_odds[1]["odd"].present?
        game.update(
          points_home: get_odd(match_odds, "Home").to_f * 10,
          points_away: get_odd(match_odds, "Away").to_f * 10
        )
      end
    end
  end

  def self.get_results_for_match(game)
    end_point = URI("#{BASE_URL}games?id=#{game.fixture_id}&league=12&season=2019-2020&timezone=Europe/Paris")
    match_results = call_api(end_point)["response"][0]["scores"]
    game.update(
      result_home: match_results["home"]["total"],
      result_away: match_results["away"]["total"]
    )
  end

  def self.call_api(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'api-basketball.p.rapidapi.com'
    request["x-rapidapi-key"] = ENV['X_RAPIDAPI_KEY']

    response = http.request(request)
    JSON.parse(response.body)
  end

  def self.points_home_negative_points
    @matches = Match.where(sport: "basketball")
    @matches.each do |game|
      if game.points_home.present?
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
  end

  def self.points_away_negative_points
    @matches = Match.where(sport: "basketball")
    @matches.each do |game|
      if game.points_away.present?
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
  end
end
