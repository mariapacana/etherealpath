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

ActiveRecord::Schema.define(version: 20150123193915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.string   "text"
    t.integer  "challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenges", force: true do |t|
    t.string   "location"
    t.string   "question"
    t.string   "response_success"
    t.string   "response_failure"
    t.boolean  "any_answer_acceptable"
    t.integer  "mission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "needs_pic"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "god_messages", force: true do |t|
    t.string   "text"
    t.string   "location"
    t.integer  "mission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "text"
    t.boolean  "incoming"
    t.boolean  "received"
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missions", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "intro"
    t.string   "warning"
    t.string   "decline_confirmation"
    t.string   "location_invite"
    t.string   "finish_confirmation"
    t.integer  "completed_challenges_required"
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participants", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "code"
    t.string   "current_challenge_id"
    t.boolean  "declined"
    t.boolean  "intro_accepted"
    t.boolean  "warning_accepted"
    t.boolean  "trial_run"
    t.boolean  "needs_help"
    t.integer  "mission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_numbers", force: true do |t|
    t.string  "number"
    t.integer "participant_id"
    t.boolean "preferred"
  end

  create_table "responses", force: true do |t|
    t.string   "text"
    t.boolean  "correct"
    t.integer  "participant_id"
    t.integer  "challenge_id"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "picture_remote_url"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
