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
  #   plus.each do |champ, number|
  #     array =
  #   end
  end
end
