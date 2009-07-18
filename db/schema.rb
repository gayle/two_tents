# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090718131239) do

  create_table "families", :force => true do |t|
    t.string  "principal"
    t.string  "photo"
    t.string  "familyname"
    t.string  "note"
    t.boolean "haswarmfuzzy"
    t.boolean "photolist"
    t.integer "participant_id"
  end

  create_table "participants", :force => true do |t|
    t.string  "lastname"
    t.string  "firstname"
    t.string  "address1"
    t.string  "address2"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "homechurch"
    t.string  "pastor"
    t.string  "email"
    t.string  "gender"
    t.string  "birthdate"
    t.string  "occupation"
    t.string  "profile"
    t.string  "grade"
    t.string  "school"
    t.string  "phone"
    t.string  "employer"
    t.integer "family_id"
    t.integer "user_id"
  end

  create_table "registrations", :force => true do |t|
    t.integer "year"
    t.integer "participant_id"
    t.string  "room"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "rooms", :force => true do |t|
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "workphone"
    t.string   "mobilephone"
    t.string   "photourl"
    t.string   "position"
    t.integer  "participant_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
