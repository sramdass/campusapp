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

ActiveRecord::Schema.define(:version => 20120114040641) do

  create_table "blood_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "details", :force => true do |t|
    t.string   "email"
    t.string   "secondary_email"
    t.string   "phone"
    t.string   "secondary_phone"
    t.string   "address"
    t.date     "dob"
    t.string   "member_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blood_group_id"
    t.integer  "member_id"
    t.integer  "branch_id"
  end

  create_table "exams", :force => true do |t|
    t.string   "name"
    t.integer  "branch_id"
    t.integer  "year_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "mark_criteria", :force => true do |t|
    t.integer  "exam_id"
    t.integer  "subject_id"
    t.float    "max_marks"
    t.float    "pass_marks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
    t.integer  "section_id"
  end

  create_table "marks", :force => true do |t|
    t.integer  "section_id"
    t.integer  "student_id"
    t.integer  "exam_id"
    t.float    "sub1"
    t.float    "sub2"
    t.float    "sub3"
    t.float    "sub4"
    t.float    "sub5"
    t.float    "sub6"
    t.float    "sub7"
    t.float    "sub8"
    t.float    "sub9"
    t.float    "sub10"
    t.float    "sub11"
    t.float    "sub12"
    t.float    "sub13"
    t.float    "sub14"
    t.float    "sub15"
    t.integer  "rank"
    t.string   "grade"
    t.integer  "arrears"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "total"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id"
    t.integer  "resource_id"
    t.integer  "privilege"
    t.integer  "constraints"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "resource_actions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "code"
    t.string   "description"
    t.integer  "resource_id"
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

  create_table "role_memberships", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "roles", :force => true do |t|
    t.integer  "branch_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sec_exam_maps", :force => true do |t|
    t.integer  "section_id"
    t.integer  "exam_id"
    t.date     "startdate"
    t.date     "enddate"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sec_student_maps", :force => true do |t|
    t.integer  "student_id"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "sec_sub_maps", :force => true do |t|
    t.integer  "section_id"
    t.integer  "subject_id"
    t.integer  "faculty_id"
    t.string   "mark_column"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.integer  "faculty_id"
    t.integer  "clazz_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "name"
    t.string   "id_no"
    t.boolean  "female"
    t.date     "date_joined"
    t.date     "date_departed"
    t.integer  "branch_id"
    t.integer  "resource_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.integer  "branch_id"
    t.integer  "year_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", :force => true do |t|
    t.string   "name"
    t.integer  "year_id"
    t.string   "branch_id"
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
