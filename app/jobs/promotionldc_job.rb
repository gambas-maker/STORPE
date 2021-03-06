class PromotionldcJob < ApplicationJob
  queue_as :default
# Nouveau niveau : Cree a la main la ligue / Ajoute dans le Job la variable d'instance du nouveau niveau / On itere dessus pour savoir si full de joueurs / Ajoute une condition championship.name == "Semi-pro"
# ATTENTION : Si ajoute un nouveau niveau, il faudra penser a ceux qui montent et ceux qui descendent de cette meme division (Semi-pro)
# Si ajout d'un niveau deplacer ce job dans le job du prochain niveau et ici appeler le prochain niveau de promotion
  def perform
    @championshipsemi = Championship.where(name: "Semi-pro")
    # Descente en division Amateur
    @championshipsemi.each do |championshipsemi|
      ranking = {}
      championshipsemi.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking[hash] = hash.number_of_points }
      if ranking.count > 8
        ranking.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: 11, season_id: Season.last.id - 2, number_of_points: 0) }
      else
        ranking.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: 11, season_id: Season.last.id - 2, number_of_points: 0) }
      end
    end
    # Montée en division Pro
    @championshipsemi.each do |championshipsemi|
      ranking2 = {}
      championshipsemi.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking2[hash] = hash.number_of_points }
      if ranking2.count > 8
        ranking2.sort_by { |k, v| v }.reverse.first(6).each { |k, v| puts k.update(championship_id: 61, season_id: Season.last.id - 2, number_of_points: 0) }
      else
        ranking2.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: 61, season_id: Season.last.id - 2, number_of_points: 0) }
      end
    end
    PromotionProJob.perform_now
  end
end
