class ChampionshipJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    @user = User.find(user_id)
    @playerseasons = PlayerSeason.where(championship_id: Championship.where(name: "CFA"))
    @championships = Championship.where(name: "CFA")
    count = []
    if PlayerSeason.exists?(user_id: @user.id)
    else
      @championships.each do |championship|
        count << championship.player_seasons.count
      end
      array = count.reject { |number| number >= 20 }
      if array.empty?
        Championship.create(season_id: Season.last.id, name: "CFA")
        PlayerSeason.create!(user_id: @user.id, season_id: Season.last.id, championship_id: Championship.last.id, number_of_points: 0)
      else
        var = count.min
        object = []
        @championships.each do |championship|
          if championship.player_seasons.count == var
            object << championship
            puts object
          else
          end
        end
        object.select { |un| un[0] }
        PlayerSeason.create!(user_id: @user.id, season_id: Season.last.id, championship_id: object[0].id, number_of_points: 0)
      end
    end
  end
end
