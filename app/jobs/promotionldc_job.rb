class PromotionldcJob < ApplicationJob
  queue_as :default

  def perform
    @champion_bas = Championship.where(name: "CFA")
    @championships = Championship.where(name: "LDC")
    @playerseasons = PlayerSeason.all
    @forecasts = Forecast.where(season_id: Season.last.id - 1)
    @championships.each do |championship|
      ranking = {}
      championship.player_seasons.where(season_id: Season.last.id - 1).select { |i| i.forecasts.exists? }.each { |hash| ranking[hash] = hash.number_of_points }
      if championship.player_seasons.count >= 8
        array = []
        @champion_bas.each do |championbas|
          championbas.player_seasons.count <= 16 ? array << championbas : array
        end
        # Nouveau niveau : Cree a la main la ligue / Ajoute dans le Job la variable d'instance du nouveau niveau / On itere dessus pour savoir si full de joueurs / Ajoute une condition championship.name == "LDC"
        # ATTENTION : Si ajoute un nouveau niveau, il faudra penser a ceux qui montent et ceux qui descendent de cette meme division (LDC)
        array.empty? ? ranking.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: Championship.create!(name: "LDC", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: array.sample.id, season_id: Season.last.id) }
      else
        @champion_bas.each do |championbas|
          array = []
          championbas.player_seasons.count <= 16 ? array << championbas : array
        end
        array.empty? ? ranking.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: Championship.create!(name: "LDC", season_id: Season.last.id).id, season_id: Season.last.id) } : ranking.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: array.sample.id, season_id: Season.last.id) }
      end
    end
    # Si ajout d'un niveau deplacer ce job dans le job du prochain niveau et ici appeler le prochain niveau de promotion
    SeasonJob.perform_now
  end
end
