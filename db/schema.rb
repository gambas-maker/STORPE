# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_17_211038) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "championships", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "season_id"
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.index ["season_id"], name: "index_championships_on_season_id"
  end

  create_table "forecasts", force: :cascade do |t|
    t.integer "points_win"
    t.integer "points_lose"
    t.boolean "confirmed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "match_id"
    t.string "outcome"
    t.bigint "player_season_id"
    t.bigint "season_id"
    t.index ["match_id"], name: "index_forecasts_on_match_id"
    t.index ["player_season_id"], name: "index_forecasts_on_player_season_id"
    t.index ["season_id"], name: "index_forecasts_on_season_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "result"
    t.string "team_home"
    t.string "team_away"
    t.string "sport"
    t.string "team_home_logo_url"
    t.string "team_away_logo_url"
    t.string "country"
    t.string "league"
    t.float "points_home"
    t.integer "negative_points_home"
    t.string "kick_off"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "points_draw"
    t.float "points_away"
    t.integer "fixture_id"
    t.integer "negative_points_draw"
    t.integer "negative_points_away"
    t.string "event_stamp"
  end

  create_table "player_seasons", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "ratio"
    t.integer "rank"
    t.integer "number_of_points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "season_id"
    t.bigint "championship_id"
    t.index ["championship_id"], name: "index_player_seasons_on_championship_id"
    t.index ["season_id"], name: "index_player_seasons_on_season_id"
    t.index ["user_id"], name: "index_player_seasons_on_user_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "start_date"
    t.integer "end_date"
    t.string "division"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "pseudo"
    t.string "last_name"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "championships", "seasons"
  add_foreign_key "forecasts", "matches"
  add_foreign_key "forecasts", "player_seasons"
  add_foreign_key "forecasts", "seasons"
  add_foreign_key "player_seasons", "championships"
  add_foreign_key "player_seasons", "seasons"
  add_foreign_key "player_seasons", "users"
end
