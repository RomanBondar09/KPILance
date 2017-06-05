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

ActiveRecord::Schema.define(version: 20161221200233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assign_tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attachment_files", force: :cascade do |t|
    t.string   "attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "task_id"
    t.string   "name"
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "subject"
    t.integer  "price"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id"
    t.integer  "estimate"
    t.boolean  "attached",    default: false
    t.integer  "employee_id"
    t.boolean  "solution",    default: false
  end

  create_table "user_ratings", force: :cascade do |t|
    t.integer  "user_sender_id"
    t.integer  "user_recipient_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "rating"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "photo_url",       default: ""
    t.integer  "rating",          default: 0
  end

end
