class PlayermouvJob < ApplicationJob
  queue_as :default

  def perform
    egal = {}
    moins = {}
    plus = {}
    @amateurs = Championship.where(name: "Amateur")
    @amateurs.each do |amateur|
      champ = []
      amateur.player_seasons.each do |player|
        if player.forecasts.where(confirmed: true).last.nil?
        else player.forecasts.exists? && player.forecasts.where(confirmed: true).last.season_id == Season.last.id
          champ << player
        end
      end
      if champ.count < 20
        moins[amateur] = champ.count
      elsif champ.count > 20
        plus[amateur] = champ.count
      else
        egal[amateur] = champ.count
      end
    end
    plus.each do |champ, number|
      array = []
      champ.player_seasons.each do |player|
        if player.forecasts.where(confirmed: true).last.nil?
        else player.forecasts.exists? && player.forecasts.where(confirmed: true).last.season_id == Season.last.id
          array << player
        end
      end
      moins.each do |key, value|
        while array.count > 20 && value < 20
          array.first.update(championship_id: key.id)
          array.delete_at(0)
          value += 1
          moins[key] += 1
        end
      end
    end
    moins.each do |key, value|
      if value == 20
        egal[key] = value
        moins.delete(key)
      elsif value == moins.max_by { |k,v| v }.second
      else
        key.player_seasons.each do |player|
          if player.forecasts.where(confirmed: true).last.nil?
          else player.forecasts.exists? && player.forecasts.where(confirmed: true).last.season_id == Season.last.id && value < 20
            puts moins.max_by { |k,v| v }.first.id
            player.update(championship_id: moins.max_by { |k,v| v }.first.id)
            value += 1
            moins[key] += 1
          end
        end
      end
    end
    PlayermouvsemiproJob.perform_now
  end
end
