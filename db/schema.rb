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

ActiveRecord::Schema.define(version: 20141210034228) do

  create_table "neural_networks", force: true do |t|
    t.integer  "years"
    t.integer  "n_input"
    t.integer  "n_hidden"
    t.integer  "n_output"
    t.text     "weights_ih"
    t.text     "weights_ho"
    t.float    "learning_rate", limit: 24
    t.float    "k",             limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "maxs"
    t.text     "mins"
    t.text     "inputs"
    t.text     "outputs"
    t.text     "avgs"
  end

  create_table "scorings", force: true do |t|
    t.string  "name",                      null: false
    t.integer "season",                    null: false
    t.integer "score",         default: 0
    t.integer "reached_count", default: 0
  end

  create_table "training_players", force: true do |t|
    t.string   "name"
    t.string   "team_a"
    t.integer  "team_a_rank"
    t.string   "team_b"
    t.integer  "team_b_rank"
    t.integer  "age"
    t.integer  "games_played"
    t.integer  "goals"
    t.integer  "assists"
    t.integer  "points"
    t.integer  "penalty_minutes"
    t.integer  "hits"
    t.integer  "blocks"
    t.integer  "pp_points"
    t.integer  "sh_points"
    t.integer  "shots"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "season"
    t.integer  "plus_minus"
    t.integer  "toi",             default: 0
    t.integer  "position"
    t.integer  "give_aways"
    t.integer  "take_aways"
  end

end
