require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class SportOdd
  BASE_URL = "https://v2.api-football.com/"
  LEAGUE_IDS = [2664, 2790, 2833, 2857, 2755, 2771, 2777, 1422, 925, 1073, 1252, 3079, 3026]
  # 2664 = France, 2790 = Angleterre, 2833 = Espagne, 2857 = Italie, 2755 = Allemagne, 2771 = Champions League, 2777 = Europa League, 1422 = Nations League, Bottola Pro = 925, CAN = 1073, World Cup South-Am-Qualif = 1252, World Cup - Qualification Europe = 3079, Women LDC = 3026

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
    end_point = URI("#{BASE_URL}fixtures/league/#{league_id}/#{date}?timezone=Europe/Paris")
    matches = call_api(end_point)["api"]["fixtures"]
    sport = "football"
    @rencontresto = Match.where(event_stamp: Date.today)
    rencontresto = []
    @rencontrestom = Match.where(event_stamp: Date.tomorrow)
    rencontrestom = []
    matches.each do |match|
      @rencontresto.each do |rencontre|
        rencontresto << rencontre.fixture_id
      end
      @rencontrestom.each do |rencontretom|
        rencontrestom << rencontretom.fixture_id
      end
      if rencontresto.include?(match["fixture_id"])
        @rencontresto.each do |rencontreto|
          if rencontreto.points_home.nil? || rencontreto.points_away.nil?
            get_odds_for_match(rencontreto)
          end
        end
      elsif rencontrestom.include?(match["fixture_id"])
        @rencontrestom.each do |rencontretom|
          if rencontretom.points_home.nil? || rencontretom.points_away.nil?
            get_odds_for_match(rencontretom)
          end
        end
      else
        new_match = Match.create(
            team_home: match["homeTeam"]["team_name"],
            team_home_logo_url: match["homeTeam"]["logo"],
            team_away: match["awayTeam"]["team_name"],
            team_away_logo_url: match["awayTeam"]["logo"],
            sport: sport,
            fixture_id: match["fixture_id"],
            country: match["league"]["country"],
            league: match["league"]["name"],
            event_stamp: DateTime.strptime(match["event_timestamp"].to_s, '%s').to_date,
            kick_off: DateTime.parse(match["event_date"])
          )
        get_odds_for_match(new_match)
        get_odds_for_match_two_teams(new_match)
        get_odds_for_match_over(new_match)
      end
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
    ok = call_api(end_point)["api"]["results"]
    if ok == 1
      answer = call_api(end_point)["api"]["odds"][0]["bookmakers"][1]["bets"][0]["label_name"]
      if answer == "Match Winner"
        match_odds = call_api(end_point)["api"]["odds"][0]["bookmakers"][1]["bets"][0]["values"]
        game.update(
          points_home: get_odd(match_odds, "Home").to_f * 10,
          points_draw: get_odd(match_odds, "Draw").to_f * 10,
          points_away: get_odd(match_odds, "Away").to_f * 10
        )
      end
    end
  end

  def self.get_results_for_match(game)
    end_point = URI("#{BASE_URL}fixtures/id/#{game.fixture_id}?timezone=Europe/Paris")
    match_results = call_api(end_point)["api"]["fixtures"][0]["score"]
    game.update(
      result: match_results["fulltime"]
    )
  end
  def self.get_odds_for_match_two_teams(game)
    end_point = URI("#{BASE_URL}odds/fixture/#{game.fixture_id}")
    ok = call_api(end_point)["api"]["results"]
    if ok == 1
      goals_two_teams = call_api(end_point)["api"]["odds"][0]["bookmakers"][0]["bets"][7]["label_name"]
      if goals_two_teams == "Both Teams Score"
        match_goals_two_teams = call_api(end_point)["api"]["odds"][0]["bookmakers"][0]["bets"][7]["values"]
        if match_goals_two_teams == nil
        else
          game.update(
            goal_two_teams_yes: get_odd(match_goals_two_teams, "Yes").to_f * 10,
            goal_two_teams_no: get_odd(match_goals_two_teams, "No").to_f * 10
          )
        end
      end
    end
  end
  def self.get_odds_for_match_over(game)
    end_point = URI("#{BASE_URL}odds/fixture/#{game.fixture_id}")
    ok = call_api(end_point)["api"]["results"]
    puts "hello"
    if ok == 1
      goals_over_under = call_api(end_point)["api"]["odds"][0]["bookmakers"][0]["bets"][3]["label_name"]
      if goals_over_under.nil?
      else
        if goals_over_under == "Goals Over/Under"
          match_over_under = call_api(end_point)["api"]["odds"][0]["bookmakers"][0]["bets"][3]["values"]
          game.update(
            over_25: get_odd(match_over_under, "Over 2.5").to_f * 10,
            under_25: get_odd(match_over_under, "Under 2.5").to_f * 10
          )
        end
      end
    end
  end

  def self.call_api(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = ENV['X_RAPIDAPI_KEY']

    response = http.request(request)
    JSON.parse(response.body)
  end

  def self.points_home_negative_points
    @matches = Match.where(sport: "football")
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
        elsif game.points_home >= 25
          game.update(negative_points_home: -5)
        end
      end
    end
  end

  def self.points_draw_negative_points
    @matches = Match.where(sport: "football")
    @matches.each do |game|
      if game.points_draw.present?
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
        elsif game.points_draw >= 25
          game.update(negative_points_draw: -5)
        end
      end
    end
  end

  def self.points_away_negative_points
    @matches = Match.where(sport: "football")
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
        elsif game.points_away >= 25
          game.update(negative_points_away: -5)
        end
      end
    end
  end
  def self.points_over25_neg_points
    @matches = Match.where(sport: "football")
    @matches.each do |game|
      if game.over_25.present?
        if game.over_25 < 11
          game.update(negative_over25: -15)
        elsif game.over_25 >= 11 && game.over_25 < 13
          game.update(negative_over25: -11)
        elsif game.over_25 >= 13 && game.over_25 < 15
          game.update(negative_over25: -10)
        elsif game.over_25 >= 15 && game.over_25 < 16
          game.update(negative_over25: -9)
        elsif game.over_25 >= 16 && game.over_25 < 18
          game.update(negative_over25: -8)
        elsif game.over_25 >= 18 && game.over_25 < 20
          game.update(negative_over25: -7)
        elsif game.over_25 >= 20 && game.over_25 < 22.5
          game.update(negative_over25: -7)
        elsif game.over_25 >= 22.5 && game.over_25 < 25
          game.update(negative_over25: -6)
        elsif game.over_25 >= 25
          game.update(negative_over25: -5)
        end
      end
    end
  end
  def self.points_under25_neg_points
    @matches = Match.where(sport: "football")
    @matches.each do |game|
      if game.under_25.present?
        if game.under_25 < 11
          game.update(negative_under25: -15)
        elsif game.under_25 >= 11 && game.under_25 < 13
          game.update(negative_under25: -11)
        elsif game.under_25 >= 13 && game.under_25 < 15
          game.update(negative_under25: -10)
        elsif game.under_25 >= 15 && game.under_25 < 16
          game.update(negative_under25: -9)
        elsif game.under_25 >= 16 && game.under_25 < 18
          game.update(negative_under25: -8)
        elsif game.under_25 >= 18 && game.under_25 < 20
          game.update(negative_under25: -7)
        elsif game.under_25 >= 20 && game.under_25 < 22.5
          game.update(negative_under25: -7)
        elsif game.under_25 >= 22.5 && game.under_25 < 25
          game.update(negative_under25: -6)
        elsif game.under_25 >= 25
          game.update(negative_under25: -5)
        end
      end
    end
  end
  def self.points_goal_two_teams_yes_neg_points
    @matches = Match.where(sport: "football")
    @matches.each do |game|
      if game.goal_two_teams_yes.present?
        if game.goal_two_teams_yes < 11
          game.update(negative_goal_two_teams_yes: -15)
        elsif game.goal_two_teams_yes >= 11 && game.goal_two_teams_yes < 13
          game.update(negative_goal_two_teams_yes: -11)
        elsif game.goal_two_teams_yes >= 13 && game.goal_two_teams_yes < 15
          game.update(negative_goal_two_teams_yes: -10)
        elsif game.goal_two_teams_yes >= 15 && game.goal_two_teams_yes < 16
          game.update(negative_goal_two_teams_yes: -9)
        elsif game.goal_two_teams_yes >= 16 && game.goal_two_teams_yes < 18
          game.update(negative_goal_two_teams_yes: -8)
        elsif game.goal_two_teams_yes >= 18 && game.goal_two_teams_yes < 20
          game.update(negative_goal_two_teams_yes: -7)
        elsif game.goal_two_teams_yes >= 20 && game.goal_two_teams_yes < 22.5
          game.update(negative_goal_two_teams_yes: -7)
        elsif game.goal_two_teams_yes >= 22.5 && game.goal_two_teams_yes < 25
          game.update(negative_goal_two_teams_yes: -6)
        elsif game.goal_two_teams_yes >= 25
          game.update(negative_goal_two_teams_yes: -5)
        end
      end
    end
  end
  def self.points_goals_two_teams_no_neg_points
    @matches = Match.where(sport: "football")
    @matches.each do |game|
      if game.goal_two_teams_no.present?
        if game.goal_two_teams_no < 11
          game.update(negative_goal_two_teams_no: -15)
        elsif game.goal_two_teams_no >= 11 && game.goal_two_teams_no < 13
          game.update(negative_goal_two_teams_no: -11)
        elsif game.goal_two_teams_no >= 13 && game.goal_two_teams_no < 15
          game.update(negative_goal_two_teams_no: -10)
        elsif game.goal_two_teams_no >= 15 && game.goal_two_teams_no < 16
          game.update(negative_goal_two_teams_no: -9)
        elsif game.goal_two_teams_no >= 16 && game.goal_two_teams_no < 18
          game.update(negative_goal_two_teams_no: -8)
        elsif game.goal_two_teams_no >= 18 && game.goal_two_teams_no < 20
          game.update(negative_goal_two_teams_no: -7)
        elsif game.goal_two_teams_no >= 20 && game.goal_two_teams_no < 22.5
          game.update(negative_goal_two_teams_no: -7)
        elsif game.goal_two_teams_no >= 22.5 && game.goal_two_teams_no < 25
          game.update(negative_goal_two_teams_no: -6)
        elsif game.goal_two_teams_no >= 25
          game.update(negative_goal_two_teams_no: -5)
        end
      end
    end
  end
end
