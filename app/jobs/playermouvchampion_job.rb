class PlayermouvchampionJob < ApplicationJob
  queue_as :default

  def perform
    egalc = {}
    moinsc = {}
    plusc = {}
    @champions = Championship.where(name: "Champion")
    @champions.each do |champion|
      champ = []
      champion.player_seasons.each do |player|
        if player.season_id == Season.last.id
          champ << player
        end
      end
      if champ.count < 20
        moinsc[champion] = champ.count
      elsif champ.count > 20
        plusc[champion] = champ.count
      else
        egalc[champion] = champ.count
      end
    end
    plusc.each do |champ, number|
      array = []
      champ.player_seasons.each do |player|
        if player.season_id == Season.last.id
          array << player
        end
      end
      moinsc.each do |key, value|
        while array.count > 20 && value < 20
          array.first.update(championship_id: key.id)
          array.delete_at(0)
          value += 1
          moinsc[key] += 1
        end
      end
    end
  end
end
