class ChampionshipJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    @user = User.find(user_id)
    if PlayerSeason.exists?(user_id: @user.id)
    else
      PlayerSeason.create!(user_id: @user.id, season_id: Season.last.id, championship_id: 27, number_of_points: 0)
    end
  end
end
