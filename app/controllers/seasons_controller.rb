class SeasonsController < ApplicationController
  def show
    @playerseason = PlayerSeason.where(user_id: current_user.id)
    @championship = Championship.where(id: current_user.player_seasons[0].championship.id)
    @playerseasons = PlayerSeason.where(championship_id: current_user.player_seasons[0].championship.id, season_id: Season.last.id)
    if current_user.club == "LOSC"
      @userslosc = User.where(club: "LOSC")
    else
    end
  end
end
