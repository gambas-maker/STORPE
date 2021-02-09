class PlayermouvproJob < ApplicationJob
  queue_as :default

  def perform
    egalp = {}
    moinsp = {}
    plusp = {}
    @pros = Championship.where(name: "Pro")
    @pros.each do |pro|
      champ = []
      pro.player_seasons.each do |player|
        if player.season_id == Season.last.id
          champ << player
        end
      end
      if champ.count < 20
        moinsp[pro] = champ.count
      elsif champ.count > 20
        plusp[pro] = champ.count
      else
        egalp[pro] = champ.count
      end
    end
    plusp.each do |champ, number|
      array = []
      champ.player_seasons.each do |player|
        if player.season_id == Season.last.id
          array << player
        end
      end
      moinsp.each do |key, value|
        while array.count > 20 && value < 20
          array.first.update(championship_id: key.id)
          array.delete_at(0)
          value += 1
          moinsp[key] += 1
        end
      end
    end
  end
end
