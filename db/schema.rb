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

ActiveRecord::Schema[8.0].define(version: 2026_11_08_120324) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "attempt_id", null: false
    t.integer "position"
    t.index ["attempt_id", "position"], name: "index_answers_on_attempt_id_and_position", unique: true
    t.index ["attempt_id", "question_id"], name: "index_answers_on_attempt_id_and_question_id", unique: true
    t.index ["attempt_id"], name: "index_answers_on_attempt_id"
    t.index ["option_id"], name: "index_answers_on_option_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "attempts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mock_id", null: false
    t.datetime "started_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "submitted_at"
    t.integer "score"
    t.index ["mock_id"], name: "index_attempts_on_mock_id"
    t.index ["user_id"], name: "index_attempts_on_user_id"
  end

  create_table "competencies", force: :cascade do |t|
    t.string "name"
    t.integer "weight"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mocks", force: :cascade do |t|
    t.string "title"
    t.integer "duration_minutes"
    t.integer "total_questions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
  end

  create_table "options", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.text "body"
    t.boolean "correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "subtopic_id", null: false
    t.text "body"
    t.text "explanation"
    t.integer "difficulty"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subtopic_id"], name: "index_questions_on_subtopic_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subtopics", force: :cascade do |t|
    t.bigint "competency_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competency_id"], name: "index_subtopics_on_competency_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "roll_number"
    t.integer "role", default: 0, null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "answers", "attempts"
  add_foreign_key "answers", "options"
  add_foreign_key "answers", "questions"
  add_foreign_key "attempts", "mocks"
  add_foreign_key "attempts", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "subtopics"
  add_foreign_key "sessions", "users"
  add_foreign_key "subtopics", "competencies"
end
