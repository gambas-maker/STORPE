class PlayermouvsemiproJob < ApplicationJob
  queue_as :default

  def perform
    egals = {}
    moinss = {}
    pluss = {}
    @semis = Championship.where(name: "Semi-pro")
    @semis.each do |semi|
      champ = []
      semi.player_seasons.each do |player|
        if player.forecasts.exists? && player.forecasts.where(confirmed: true).last.season_id == Season.last.id
          champ << player
        end
      end
      if champ.count < 20
        moinss[semi] = champ.count
      elsif champ.count > 20
        pluss[semi] = champ.count
      else
        egals[semi] = champ.count
      end
    end
    pluss.each do |champ, number|
      array = []
      champ.player_seasons.each do |player|
        if player.forecasts.exists? && player.forecasts.where(confirmed: true).last.season_id == Season.last.id
          array << player
        end
      end
      moinss.each do |key, value|
        while array.count > 20 && value < 20
          array.first.update(championship_id: key.id)
          array.delete_at(0)
          value += 1
          moinss[key] += 1
        end
      end
    end
    moinss.each do |key, value|
      if value == 20
        egals[key] = value
        moinss.delete(key)
      elsif value == moinss.max_by { |k,v| v }.second
      else
        key.player_seasons.each do |player|
          if player.forecasts.exists? && player.forecasts.where(confirmed: true).last.season_id == Season.last.id && value < 20
            puts moinss.max_by { |k,v| v }.first.id
            player.update(championship_id: moinss.max_by { |k,v| v }.first.id)
            value += 1
            moinss[key] += 1
          end
        end
      end
    end
    PlayermouvproJob.perform_now
  end
end
