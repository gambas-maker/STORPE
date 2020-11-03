class PromotionldcJob < ApplicationJob
  queue_as :default

  def perform
    @champion_bas = Championship.where(name: "Amateur")
    @championships = Championship.where(name: "Semi-pro")
    @championshippro = Championship.where(name: "Pro")
    @playerseasons = PlayerSeason.all
    @forecasts = Forecast.where(season_id: Season.last.id - 1)
    # Descente en division Amateur
    @championships.each do |championship|
      ranking = {}
      championship.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.each { |hash| ranking[hash] = hash.number_of_points }
      if ranking.count >= 8
        array = []
        @champion_bas.each do |championbas|
          championbas.player_seasons.count <= 25 ? array << championbas : array
        end
        # Nouveau niveau : Cree a la main la ligue / Ajoute dans le Job la variable d'instance du nouveau niveau / On itere dessus pour savoir si full de joueurs / Ajoute une condition championship.name == "Semi-pro"
        # ATTENTION : Si ajoute un nouveau niveau, il faudra penser a ceux qui montent et ceux qui descendent de cette meme division (Semi-pro)
        array.empty? ? ranking.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: Championship.create!(name: "Amateur", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: array.sample.id, season_id: Season.last.id) }
      else
        array = []
        @champion_bas.each do |championbas|
          championbas.player_seasons.count <= 25 ? array << championbas : array
        end
        array.empty? ? ranking.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: Championship.create!(name: "Amateur", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: array.sample.id, season_id: Season.last.id) }
      end
    end
    # Montée en division Pro
    @championships.each do |championship|
      ranking2 = {}
      championship.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.where(season_id: Season.last.id - 1).exists? }.each { |hash| ranking2[hash] = hash.number_of_points }
      if ranking2.count >= 8
        array2 = []
        @championshippro.each do |championshippro|
          championshippro.player_seasons.count <= 16 ? array2 << championshippro : array2
        end
        array2.empty? ? ranking2.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: Championship.create!(name: "Pro", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking2.sort_by { |k, v| v }.reverse.first(4).each { |k, v| puts k.update(championship_id: array2.sample.id, season_id: Season.last.id) }
      else
        array2 = []
        @championshippro.each do |championshippro|
          championshippro.player_seasons.count <= 16 ? array2 << championshippro : array2
        end
        array2.empty? ? ranking2.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: Championship.create!(name: "Pro", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking2.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: array2.sample.id, season_id: Season.last.id) }
      end
    end
    # Si ajout d'un niveau deplacer ce job dans le job du prochain niveau et ici appeler le prochain niveau de promotion
    PromotionProJob.perform_now
  end
end
