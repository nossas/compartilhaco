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

ActiveRecord::Schema.define(version: 20140815104809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaign_spreaders", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timeline_id",   null: false
    t.string   "timeline_type", null: false
  end

  create_table "campaigns", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    null: false
    t.string   "uid",        null: false
    t.string   "token",      null: false
    t.datetime "expires_at", null: false
    t.index ["uid"], :name => "index_facebook_profiles_on_uid", :unique => true
    t.index ["user_id"], :name => "index_facebook_profiles_on_user_id", :unique => true
  end

  create_table "users", force: true do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "ip"
  end

end
