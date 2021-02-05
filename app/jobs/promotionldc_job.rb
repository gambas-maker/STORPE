class PromotionldcJob < ApplicationJob
  queue_as :default
# Nouveau niveau : Cree a la main la ligue / Ajoute dans le Job la variable d'instance du nouveau niveau / On itere dessus pour savoir si full de joueurs / Ajoute une condition championship.name == "Semi-pro"
# ATTENTION : Si ajoute un nouveau niveau, il faudra penser a ceux qui montent et ceux qui descendent de cette meme division (Semi-pro)
# Si ajout d'un niveau deplacer ce job dans le job du prochain niveau et ici appeler le prochain niveau de promotion
  def perform
    @champion_bas = Championship.where(name: "Amateur")
    @championships = Championship.where(name: "Semi-pro")
    @championshippro = Championship.where(name: "Pro")
    # Descente en division Amateur
    @championships.each do |championship|
      ranking = {}
      championship.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking[hash] = hash.number_of_points }
      if ranking.count >= 8
        array = []
        @champion_bas.each do |championbas|
          array << championbas
        end
        ranking.sort_by { |k, v| v }.reverse.last(4).each { |k, v| puts k.update(championship_id: array.first.id) }
      else
        array = []
        @champion_bas.each do |championbas|
          arra << championbas
        end
        ranking.sort_by { |k, v| v }.reverse.last(2).each { |k, v| puts k.update(championship_id: array.first.id) }
      end
    end
    # Montée en division Pro
    @championships.each do |championship|
      ranking2 = {}
      championship.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking2[hash] = hash.number_of_points }
      if ranking2.count >= 8
        array2 = []
        @championshippro.each do |championshippro|
          array2 << championshippro
        end
        ranking2.sort_by { |k, v| v }.reverse.first(6).each { |k, v| puts k.update(championship_id: array2.first.id) }
      else
        array2 = []
        @championshippro.each do |championshippro|
          array2 << championshippro
        end
        ranking2.sort_by { |k, v| v }.reverse.first(2).each { |k, v| puts k.update(championship_id: array2.first.id) }
      end
    end
    PromotionProJob.perform_now
  end
end
