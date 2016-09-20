# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160917222556) do

  create_table "cardlocations", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "deck_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "card_order"
    t.integer  "cardmapping_id"
  end

  add_index "cardlocations", ["card_id", "deck_id"], name: "index_cardlocations_on_card_id_and_deck_id", unique: true
  add_index "cardlocations", ["card_id"], name: "index_cardlocations_on_card_id", unique: true
  add_index "cardlocations", ["deck_id"], name: "index_cardlocations_on_deck_id"

  create_table "cardmappings", force: :cascade do |t|
    t.string   "name"
    t.string   "text"
    t.boolean  "is_action"
    t.boolean  "is_attack"
    t.boolean  "is_reaction"
    t.boolean  "is_treasure"
    t.boolean  "is_victory"
    t.integer  "treasure_amount"
    t.integer  "victory_points"
    t.integer  "cost"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "cardmappings", ["name"], name: "index_cardmappings_on_name", unique: true

  create_table "cards", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "cardlocation_id"
  end

  create_table "decks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "player_id"
    t.string   "status"
    t.integer  "game_id"
  end

  create_table "gamemanagers", force: :cascade do |t|
    t.integer  "player_turn"
    t.integer  "actions"
    t.integer  "treasure"
    t.integer  "buys"
    t.string   "phase"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "game_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "status"
    t.integer  "gamemanager_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "turn_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
