class ChampionshipJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    @user = User.find(user_id)
    @playerseasons = PlayerSeason.where(championship_id: Championship.where(name: "Amateur"))
    @championships = Championship.where(name: "Amateur")
    hash = {}
    array = []
    if PlayerSeason.exists?(user_id: @user.id)
    else
      @championships.each do |championship|
        player = []
        championship.player_seasons.each do |playerseason|
          if playerseason.forecasts.where(season_id: Season.last.id).exists?
            player << playerseason
            if player.count < 20
              puts player
              hash[championship.id] = player.count
              puts hash
              array << championship
              puts array
            end
          end
        end
      end
      if array.empty?
        Championship.create(season_id: Season.last.id, name: "Amateur")
        PlayerSeason.create!(user_id: @user.id, season_id: Season.last.id, championship_id: Championship.last.id, number_of_points: 0)
      else
        PlayerSeason.create!(user_id: @user.id, season_id: Season.last.id, championship_id: hash.max_by{ |k,v| v }.first, number_of_points: 0)
      end
    end
  end
end
