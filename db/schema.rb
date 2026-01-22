
ActiveRecord::Schema.define(version: 2026_01_12_154454) do

  create_table "artists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "nickname"
    t.string "image"
    t.string "genre"
    t.bigint "user_id"
    t.text "memo"
    t.boolean "nickname_mode", default: false
    t.boolean "favorited", default: false
    t.date "founding_date"
    t.date "first_show_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_artists_on_name"
    t.index ["nickname"], name: "index_artists_on_nickname"
    t.index ["user_id"], name: "index_artists_on_user_id"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "goods", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "name"
    t.integer "quantity"
    t.integer "price"
    t.bigint "user_id", null: false
    t.bigint "artist_id"
    t.bigint "member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "date"
    t.bigint "live_schedule_id"
    t.index ["artist_id"], name: "index_goods_on_artist_id"
    t.index ["category_id"], name: "index_goods_on_category_id"
    t.index ["live_schedule_id"], name: "index_goods_on_live_schedule_id"
    t.index ["member_id"], name: "index_goods_on_member_id"
    t.index ["user_id"], name: "index_goods_on_user_id"
  end

  create_table "live_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "artist_id"
    t.date "date"
    t.time "start_time"
    t.bigint "venue_id", null: false
    t.integer "ticket_price"
    t.integer "drink_price"
    t.string "timetable"
    t.string "announcement_image"
    t.text "memo"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_live_records_on_artist_id"
    t.index ["user_id"], name: "index_live_records_on_user_id"
    t.index ["venue_id"], name: "index_live_records_on_venue_id"
  end

  create_table "live_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "artist_id"
    t.date "date"
    t.time "open_time"
    t.time "start_time"
    t.bigint "venue_id", null: false
    t.integer "ticket_status"
    t.integer "ticket_price"
    t.integer "drink_price"
    t.datetime "ticket_sale_date"
    t.string "timetable"
    t.string "announcement_image"
    t.text "memo"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.index ["artist_id"], name: "index_live_schedules_on_artist_id"
    t.index ["status"], name: "index_live_schedules_on_status"
    t.index ["user_id"], name: "index_live_schedules_on_user_id"
    t.index ["venue_id"], name: "index_live_schedules_on_venue_id"
  end

  create_table "members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "artist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_members_on_artist_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "avatar"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "google_place_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude"
    t.float "longitude"
    t.string "area"
    t.index ["user_id"], name: "index_venues_on_user_id"
  end

  add_foreign_key "artists", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "goods", "artists"
  add_foreign_key "goods", "categories"
  add_foreign_key "goods", "live_schedules"
  add_foreign_key "goods", "members"
  add_foreign_key "goods", "users"
  add_foreign_key "live_records", "artists"
  add_foreign_key "live_records", "users"
  add_foreign_key "live_records", "venues"
  add_foreign_key "live_schedules", "artists"
  add_foreign_key "live_schedules", "users"
  add_foreign_key "live_schedules", "venues"
  add_foreign_key "members", "artists"
  add_foreign_key "venues", "users"
end
