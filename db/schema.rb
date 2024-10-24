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

ActiveRecord::Schema[7.2].define(version: 2024_10_24_132239) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "attachmentcounters", force: :cascade do |t|
    t.bigint "attachment_id", null: false
    t.bigint "user_id", null: false
    t.boolean "aproved", default: false
    t.boolean "rejected", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_id"], name: "index_attachmentcounters_on_attachment_id"
    t.index ["user_id"], name: "index_attachmentcounters_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "perspective_id", null: false
    t.string "filename"
    t.string "type_content"
    t.binary "content"
    t.string "status", default: "in_analysis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perspective_id"], name: "index_attachments_on_perspective_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_calendars_on_organization_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "consultations", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "log_entries", force: :cascade do |t|
    t.string "controller_name"
    t.text "info"
    t.datetime "created_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perspectives", force: :cascade do |t|
    t.text "copy"
    t.bigint "post_id", null: false
    t.bigint "socialplatform_id"
    t.string "status", default: "in_analysis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_perspectives_on_post_id"
    t.index ["socialplatform_id"], name: "index_perspectives_on_socialplatform_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "design_idea"
    t.string "categories", default: [], array: true
    t.bigint "user_id", null: false
    t.bigint "calendar_id", null: false
    t.string "status", default: "in_analysis"
    t.datetime "publish_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_posts_on_calendar_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "socialplatforms", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.string "link_form"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.boolean "isLeader", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attachmentcounters", "attachments"
  add_foreign_key "attachmentcounters", "users"
  add_foreign_key "attachments", "perspectives"
  add_foreign_key "calendars", "organizations"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "perspectives", "posts"
  add_foreign_key "perspectives", "socialplatforms"
  add_foreign_key "posts", "calendars"
  add_foreign_key "posts", "users"
end
