# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_17_120343) do
  create_table "app_opens", force: :cascade do |t|
    t.string "device_id"
    t.string "version_name"
    t.string "version_code"
    t.string "security_token"
    t.string "app_url"
    t.string "social_name"
    t.string "social_img_url"
    t.string "social_email"
    t.string "force_update", default: "false"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "device_details", force: :cascade do |t|
    t.string "device_id"
    t.string "device_type"
    t.string "device_name"
    t.string "advertising_id"
    t.string "version_name"
    t.string "version_code"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_term"
    t.string "referrer_url"
    t.string "user_id"
    t.string "security_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.string "mid"
    t.string "cid"
    t.string "title"
    t.string "status"
    t.string "short_title"
    t.string "match_type"
    t.string "teama_name"
    t.string "teama_logo"
    t.string "teamb_name"
    t.string "teamb_logo"
    t.string "venue_name"
    t.string "venue_location"
    t.string "venue_country"
    t.string "teama_scores_full"
    t.string "teama_scores"
    t.string "teama_overs"
    t.string "teamb_scores_full"
    t.string "teamb_scores"
    t.string "teamb_overs"
    t.string "match_time"
    t.string "match_end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
