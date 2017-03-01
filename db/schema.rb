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

ActiveRecord::Schema.define(version: 20170301085832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auction_products", force: :cascade do |t|
    t.string   "name"
    t.integer  "auction_id"
    t.integer  "price"
    t.text     "description"
    t.boolean  "sold"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "auctions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "archived",    default: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "place"
    t.date     "event_date"
    t.integer  "manager_kw_id"
    t.string   "participants"
    t.string   "application_list_url"
    t.integer  "price_for_members"
    t.integer  "price_for_non_members"
    t.date     "application_date"
    t.date     "payment_date"
    t.string   "account_number"
    t.string   "event_rules_url"
    t.string   "google_group_discussion_url"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "display_name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "description"
    t.boolean  "rentable",     default: false
    t.integer  "owner",        default: 0
    t.integer  "cost",         default: 0
    t.integer  "rentable_id"
  end

  create_table "membership_fees", force: :cascade do |t|
    t.string   "year"
    t.integer  "cost",         default: 100
    t.integer  "kw_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reactivation", default: false
    t.index ["kw_id"], name: "index_membership_fees_on_kw_id", using: :btree
  end

  create_table "mountain_routes", force: :cascade do |t|
    t.integer "user_id"
    t.string  "name"
    t.text    "description"
    t.string  "difficulty"
    t.string  "partners"
    t.integer "rating"
    t.date    "climbing_date"
    t.string  "peak"
    t.string  "time"
    t.integer "peak_id"
    t.integer "route_type",    default: 0
    t.string  "area"
    t.integer "length"
    t.string  "mountains"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cost"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "order_id"
    t.boolean  "cash",       default: false
    t.string   "dotpay_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",      default: "unpaid"
  end

  create_table "peaks", force: :cascade do |t|
    t.string  "name"
    t.integer "valley_id"
  end

  create_table "product_fields", force: :cascade do |t|
    t.string   "name"
    t.string   "field_type"
    t.boolean  "required"
    t.integer  "product_type_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["product_type_id"], name: "index_product_fields_on_product_type_id", using: :btree
  end

  create_table "product_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "kw_id",                                 null: false
    t.date     "birth_date",                            null: false
    t.string   "birth_place",                           null: false
    t.string   "pesel",                                 null: false
    t.string   "city",                                  null: false
    t.string   "postal_code",                           null: false
    t.string   "main_address",                          null: false
    t.string   "optional_address"
    t.text     "recommended_by",        default: [],                 array: true
    t.integer  "acomplished_courses",   default: [],                 array: true
    t.boolean  "main_discussion_group", default: false
    t.text     "sections",              default: [],                 array: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "accepted",              default: false
    t.index ["kw_id"], name: "index_profiles_on_kw_id", unique: true, using: :btree
  end

  create_table "reservation_items", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "reservation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "state",       default: "reserved"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.date     "start_date"
    t.date     "end_date"
    t.text     "description"
    t.boolean  "canceled",    default: false
  end

  create_table "services", force: :cascade do |t|
    t.string  "serviceable_type"
    t.integer "serviceable_id"
    t.integer "order_id"
  end

  create_table "strzelecki_sign_ups", force: :cascade do |t|
    t.string   "name_1"
    t.string   "email_1"
    t.boolean  "single",         default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "organization_1"
    t.boolean  "vege_1",         default: false
    t.integer  "birth_year_1"
    t.integer  "gender_1",       default: 0
    t.integer  "package_type_1", default: 0
    t.text     "remarks"
    t.string   "name_2"
    t.string   "birth_year_2"
    t.boolean  "vege_2",         default: false
    t.string   "email_2"
    t.string   "organization_2"
    t.string   "city_1"
    t.string   "city_2"
    t.integer  "package_type_2", default: 0
    t.string   "phone_1"
    t.string   "phone_2"
    t.integer  "gender_2"
    t.integer  "tshirt_size_1"
    t.integer  "tshirt_size_2"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "kw_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "admin",                  default: false, null: false
    t.integer  "warnings",               default: 0
    t.string   "phone"
    t.boolean  "curator",                default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "valleys", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "product_fields", "product_types"
end
