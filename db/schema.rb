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

ActiveRecord::Schema.define(version: 20150322205008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "age_groups", force: true do |t|
    t.string   "text"
    t.integer  "min"
    t.integer  "max"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sortby"
  end

  create_table "audit_trails", force: true do |t|
    t.string   "message"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "families", force: true do |t|
    t.string  "familyname"
    t.string  "note"
    t.integer "participant_id"
    t.boolean "infosheet",           default: false
    t.integer "number_of_photo_cds", default: 1
  end

  create_table "families_years", id: false, force: true do |t|
    t.integer  "family_id"
    t.integer  "year_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participants", force: true do |t|
    t.string   "lastname"
    t.string   "firstname"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "homechurch"
    t.string   "pastor"
    t.string   "email"
    t.string   "gender"
    t.string   "occupation"
    t.string   "profile"
    t.string   "grade"
    t.string   "school"
    t.string   "phone"
    t.string   "employer"
    t.integer  "family_id"
    t.integer  "user_id"
    t.boolean  "health",                           default: false
    t.boolean  "liability",                        default: false
    t.datetime "birthdate"
    t.boolean  "main_contact",                     default: false
    t.string   "mobile"
    t.string   "trivia",               limit: 500
    t.text     "dietary_restrictions"
  end

  create_table "participants_years", id: false, force: true do |t|
    t.integer  "participant_id"
    t.integer  "year_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string "name"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "rooms", force: true do |t|
    t.boolean "availability"
    t.integer "beds",         default: 0
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data",       limit: 1024
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "user_sessions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "name",                      limit: 100, default: ""
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.datetime "remember_token_expires_at"
    t.string   "position"
    t.string   "security_question"
    t.string   "security_answer"
    t.string   "head_shot_content_type"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

  create_table "years", force: true do |t|
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "theme"
    t.date     "starts_on"
    t.date     "ends_on"
    t.string   "registration_doc"
    t.string   "registration_pdf"
  end

end
