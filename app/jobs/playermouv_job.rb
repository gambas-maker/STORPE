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
        if player.forecasts.exists? && player.forecasts.where(confirmed: true).last.season_id == Season.last.id
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
      x = number - 20
      champ.player_seasons.each do |player|
        if player.forecasts.exists? && player.forecasts.where(confirmed: true).last.season_id == Season.last.id
          array << player
        end
      end
      moins.each do |key, value|
        puts array.count
        if value < 21 && array.count > 0
          x.times do
            array.first.update(championship_id: key.id)
            array.delete_at(0)
            puts array.count
            moins[key] = value + 1
            puts moins
          end
        else array.count == 0
        end
      end
    end

  end
end
