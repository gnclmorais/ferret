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

ActiveRecord::Schema.define(version: 20180314093209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "maps", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id", null: false
    t.index ["owner_id"], name: "index_maps_on_owner_id"
  end

  create_table "pins", force: :cascade do |t|
    t.bigint "place_id", null: false
    t.bigint "map_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", null: false
    t.index ["map_id"], name: "index_pins_on_map_id"
    t.index ["place_id"], name: "index_pins_on_place_id"
  end

  create_table "pins_tags", id: false, force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "pin_id", null: false
    t.index ["tag_id", "pin_id"], name: "index_pins_tags_on_tag_id_and_pin_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "google_place_id", null: false
    t.string "name", null: false
    t.text "address", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "maps", "users", column: "owner_id", on_delete: :cascade
  add_foreign_key "pins", "maps"
  add_foreign_key "pins", "places"
end
