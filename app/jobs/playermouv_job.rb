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
        puts player.id
        puts player.forecasts.last
        if player.forecasts.exists? && player.forecasts.last.season_id == Season.last.id
          champ << player
          puts champ
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
    puts egal
    puts moins
    puts plus
    plus.each do |champ, number|
      array = []
      champ.player_seasons.each do |player|
        if player.forecasts.exists? && player.forecasts.last.season_id == Season.last.id
          array << player
        end
      end
      moins.each do |key, value|
        if value < 21 && array.count.positive?
          array.first.update(championship_id: key.id)
          array.delete_at(0)
          moins[key] = value + 1
        end
      end
    end
  end
end
