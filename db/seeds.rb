# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'uri'
require 'net/http'
require 'openssl'
require 'json'

url = URI("https://api-football-v1.p.rapidapi.com/v2/odds/league/1383?page=2")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
request["x-rapidapi-key"] = '66ffc34423msh0c2c25d40ae94fbp153beajsn6c4930448075'

response = http.request(request)
bon = JSON.parse(response.body)

Match.destroy_all

Match.create(points: (bon["api"]["odds"][0]["bookmakers"][0]["bets"][0]["values"][0]["odd"].to_i) )

