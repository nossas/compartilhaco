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

ActiveRecord::Schema.define(version: 20141114163846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       null: false
  end

  create_table "campaigns", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image",                                      null: false
    t.string   "share_link",                                 null: false
    t.datetime "shared_at"
    t.datetime "ends_at",                                    null: false
    t.integer  "goal",                                       null: false
    t.integer  "organization_id",                            null: false
    t.string   "mailchimp_segment_uid"
    t.string   "title",                                      null: false
    t.text     "description",                                null: false
    t.integer  "user_id",                                    null: false
    t.integer  "category_id",                                null: false
    t.text     "tweet",                                      null: false
    t.text     "new_campaign_spreader_mail",                 null: false
    t.datetime "archived_at"
    t.string   "hashtag"
    t.string   "facebook_title"
    t.text     "facebook_message"
    t.string   "facebook_image"
    t.boolean  "end_emails_sent",            default: false
    t.text     "short_description"
    t.boolean  "delivered_expiring_alert",   default: false
    t.index ["category_id"], :name => "fk__campaigns_category_id"
    t.foreign_key ["category_id"], "categories", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_campaigns_category_id"
  end

  create_table "campaign_spreaders", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timeline_id",   null: false
    t.string   "timeline_type", null: false
    t.integer  "campaign_id",   null: false
    t.text     "message"
    t.string   "uid"
    t.index ["campaign_id"], :name => "fk__campaign_spreaders_campaign_id"
    t.foreign_key ["campaign_id"], "campaigns", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_campaign_spreaders_campaign_id"
  end

  create_table "facebook_profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",           null: false
    t.string   "uid",               null: false
    t.string   "token",             null: false
    t.datetime "expires_at",        null: false
    t.integer  "friends_count"
    t.integer  "subscribers_count"
    t.index ["uid"], :name => "index_facebook_profiles_on_uid", :unique => true
    t.index ["user_id"], :name => "index_facebook_profiles_on_user_id", :unique => true
  end

  create_view "facebook_profile_spreaders", " SELECT cs.id,\n    fp.user_id,\n    cs.created_at,\n    cs.campaign_id\n   FROM (campaign_spreaders cs\n   JOIN facebook_profiles fp ON (((cs.timeline_id = fp.id) AND ((cs.timeline_type)::text = 'FacebookProfile'::text))))", :force => true
  create_table "mobilizations", force: true do |t|
    t.string "title"
    t.string "hashtag"
  end

  create_table "organizations", force: true do |t|
    t.text   "email_signature_html"
    t.string "city"
    t.string "mailchimp_list_id"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.string   "cas_ticket"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cas_ticket"], :name => "index_sessions_on_cas_ticket"
    t.index ["session_id"], :name => "index_sessions_on_session_id"
    t.index ["updated_at"], :name => "index_sessions_on_updated_at"
  end

  create_table "spam_reports", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id", null: false
    t.integer  "user_id",     null: false
    t.index ["campaign_id", "user_id"], :name => "index_spam_reports_on_campaign_id_and_user_id", :unique => true
    t.index ["campaign_id"], :name => "fk__spam_reports_campaign_id"
    t.foreign_key ["campaign_id"], "campaigns", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_spam_reports_campaign_id"
  end

  create_table "twitter_profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",         null: false
    t.string   "uid",             null: false
    t.string   "token",           null: false
    t.integer  "followers_count"
    t.string   "secret",          null: false
    t.index ["uid"], :name => "index_twitter_profiles_on_uid", :unique => true
    t.index ["user_id"], :name => "index_twitter_profiles_on_user_id", :unique => true
  end

  create_view "twitter_profile_spreaders", " SELECT cs.id,\n    tp.user_id,\n    cs.created_at,\n    cs.campaign_id\n   FROM (campaign_spreaders cs\n   JOIN twitter_profiles tp ON (((cs.timeline_id = tp.id) AND ((cs.timeline_type)::text = 'TwitterProfile'::text))))", :force => true
  create_table "users", force: true do |t|
    t.string  "email"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "ip"
    t.string  "avatar"
    t.boolean "admin"
    t.string  "password"
  end

end
