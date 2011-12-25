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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111225045922) do

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "resource_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clazzs", :force => true do |t|
    t.string   "name"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year_id"
  end

  create_table "faculties", :force => true do |t|
    t.string   "name"
    t.boolean  "female"
    t.date     "date_joined"
    t.date     "date_departed"
    t.integer  "branch_id"
    t.integer  "resource_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id_no"
  end

  create_table "resource_types", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_profiles", :force => true do |t|
    t.string   "login"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "password_reset_token"
    t.string   "auth_token"
    t.datetime "password_reset_sent_at"
    t.string   "user_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "years", :force => true do |t|
    t.string   "year"
    t.boolean  "current"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
