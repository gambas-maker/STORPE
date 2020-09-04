# config/sitemap.rb
SitemapGenerator::Sitemap.default_host = "https://www.storpe.club" # Your Domain Name
SitemapGenerator::Sitemap.public_path = 'tmp/sitemap'
# Where you want your sitemap.xml.gz file to be uploaded.
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
aws_access_key_id: ENV["S3_ACCESS_KEY"],
aws_secret_access_key: ENV["S3_SECRET_KEY"],
fog_provider: 'AWS',
fog_directory: ENV["S3_BUCKET_NAME"],
fog_region: ENV["S3_REGION"]
)

# The full path to your bucket
SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV["S3_BUCKET_NAME"]}.s3.amazonaws.com"
# The paths that need to be included into the sitemap.
SitemapGenerator::Sitemap.create do
    Match.find_each do |match|
     add matches_path(match, locale: :fr)
    endgit
    Season.find_each do |season|
     add season_path(season, locale: :fr)
    end
    PlayerSeason.find_each do |playerseason|
     add player_season_path(playerseason, locale: :fr)
     add edit_player_season_path(playerseason, locale: :fr)
    end

    add "fr/single-page"
    add "fr/starters-website"
    add "fr/website-op-maat"
    add "fr/webapplicatie"
    add "fr/website-analyse"
end
