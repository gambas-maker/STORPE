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
        league: match["league"]["name"],
        event_stamp: DateTime.strptime(match["event_timestamp"].to_s, '%s').to_date,
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


  def self.call_api(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'api-basketball.p.rapidapi.com'
    request["x-rapidapi-key"] = '66ffc34423msh0c2c25d40ae94fbp153beajsn6c4930448075'

    response = http.request(request)
    JSON.parse(response.body)
  end
end
