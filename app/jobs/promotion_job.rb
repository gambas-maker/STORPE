class PromotionJob < ApplicationJob
  queue_as :default

  def perform
    Season.create(id: Season.last.id + 1, start_date: Date.today.to_s, end_date: (Date.today + 6).to_s)
    puts "New season is ready"
    # Montée en Semi-Pro
    @championshipama = Championship.where(name: "Amateur")
    rankingmontsemi = {}

    # Descente/Montée en Amateur - Pro
    @championshipsemi = Championship.where(name: "Semi-pro")
    rankingdescama = {}
    rankingmontpro = {}

    # Descentre/Montée en Semi - Champion
    @championshippros = Championship.where(name: "Pro")
    rankingdescsemi = {}
    rankingmontchamp = {}

    # Descente en Pro
    @championshipchams = Championship.where(name: "Champion")
    rankingdescpro = {}


    # Montée en Semi-Pro
    @championshipama.each do |championshipama|
      ranking = {}
      championshipama.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking[hash] = hash.number_of_points }
      if ranking.count > 8
        ranking.sort_by { |k, v| v }.reverse.first(8).each { |hash| rankingmontsemi[hash] = hash.championship_id}
      else
        ranking.sort_by { |k, v| v }.reverse.first(2).each { |hash| rankingmontsemi[hash] = hash.championship_id}
      end
    end

    # Descente en Amateur
    @championshipsemi.each do |championshipsemi|
      ranking = {}
      championshipsemi.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking[hash] = hash.number_of_points }
      if ranking.count > 8
        ranking.sort_by { |k, v| v }.reverse.last(4).each { |hash| rankingdescama[hash] = hash.championship_id }
      else
        ranking.sort_by { |k, v| v }.reverse.last(2).each { |hash| rankingdescama[hash] = hash.championship_id }
      end
    end
    # Montée en Pro
    @championshipsemi.each do |championshipsemi|
      ranking2 = {}
      championshipsemi.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking2[hash] = hash.number_of_points }
      if ranking2.count > 8
        ranking2.sort_by { |k, v| v }.reverse.first(6).each { |hash| rankingmontpro[hash] = hash.championship_id }
      else
        ranking2.sort_by { |k, v| v }.reverse.first(2).each { |hash| rankingmontpro[hash] = hash.championship_id }
      end
    end

    # Descente en division Semi-pro
    @championshippros.each do |championshippro|
      ranking3 = {}
      championshippro.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking3[hash] = hash.number_of_points }
      if ranking3.count > 8
        ranking3.sort_by { |k, v| v }.reverse.last(4).each { |hash| rankingdescsemi[hash] = hash.championship_id }
      else
        ranking3.sort_by { |k, v| v }.reverse.last(2).each { |hash| rankingdescsemi[hash] = hash.championship_id }
      end
    end
    # Montée en division Champion
    @championshippros.each do |championshippro|
      ranking5 = {}
      championshippro.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking5[hash] = hash.number_of_points }
      if ranking5.count > 8
        ranking5.sort_by { |k, v| v }.reverse.first(4).each { |hash| rankingmontchamp[hash] = hash.championship_id }
      else
        ranking5.sort_by { |k, v| v }.reverse.first(2).each { |hash| rankingmontchamp[hash] = hash.championship_id }
      end
    end

    # Descente en Pro
    @championshipchams.each do |championshipcham|
      ranking4 = {}
      championshipcham.player_seasons.where(season_id: Season.last.id - 1).each { |hash| ranking4[hash] = hash.number_of_points }
      if ranking4.count > 8
        ranking4.sort_by { |k, v| v }.reverse.last(4).each { |hash| rankingdescpro[hash] = hash.championship_id }
      else
        ranking4.sort_by { |k, v| v }.reverse.last(2).each { |hash| rankingdescpro[hash] = hash.championship_id }
      end
    end

    rankingmontsemi.each do |k, v|
      k.update(championship_id: 4)
      puts k.user.email
      puts k.user.name
    end
    rankingdescama.each do |k,v|
      k.update(championship_id: 11)
      puts k.user.email
      puts k.user.name
    end
    rankingmontpro.each do |k,v|
      k.update(championship_id: 61)
      puts k.user.email
      puts k.user.name
    end
    rankingdescsemi.each do |k,v|
      k.update(championship_id: 4)
      puts k.user.email
      puts k.user.name
    end
    rankingmontchamp.each do |k,v|
      k.update(championship_id: 255)
      puts k.user.email
      puts k.user.name
    end
    rankingdescpro.each do |k,v|
      k.update(championship_id: 61)
      puts k.user.email
      puts k.user.name
    end
    #PromotionldcJob.perform_now
    SeasonJob.perform_now
  end
end
