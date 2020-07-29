class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    @champion_bas = Championship.where(name: "CFA")
    @champ = Championship.where(name: "LDC")
    @championships = Championship.all
    @playerseasons = PlayerSeason.all
    @forecasts = Forecast.where(season_id: Season.last.id)
    @championships.each do |championship|
      ranking = {}
      championship.player_seasons.each { |hash| ranking[hash] = hash.number_of_points }
      if championship.player_seasons.count >= 8
        if championship.name == "CFA"
          # if @championships.where(name: "LDC").exists?
          # Nouveau niveau : Cree a la main la ligue / Ajoute dans le Job la variable d'instance du nouveau niveau / On itère dessus pour savoir si full de joueurs / Ajoute une condition championship.name == "LDC"
          @champ.each do |champion|
            if champion.player_seasons.count <= 20
              ranking.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: champion.id) }
            else
              ranking.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: Championship.create!(name: "LDC", season_id: Season.last.id).id) }
            end
          end
          # else
          #   Championship.create!(name: "LDC", season_id: Season.last.id)
          #   puts ranking.class
          #   ranking.each { |x| puts x }
          # end
        else championship.name == "LDC"
          @champion_bas.each do |championbas|
            if championbas.player_seasons.count <= 20
              ranking.sort_by { |k, v| k.forecasts.where(season_id: Season.last.id).exists? v }.reverse.last(4).each { |k, v| puts k.update(championship_id: championbas.id) }
            else

            end
          end
        end
      else championship.player_seasons.count < 8
        array << ranking.sort_by { |k, v| v }.reverse.first(2)
        array_1 << ranking.sort_by { |k, v| k.forecasts.where(season_id: Season.last.id).exists? v }.reverse.last(2)
      end
    end
  end
end
