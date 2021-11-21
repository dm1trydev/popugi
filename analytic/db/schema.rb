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

ActiveRecord::Schema.define(version: 2021_11_18_173431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "email"
    t.string "full_name"
    t.string "role"
    t.uuid "public_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_id"], name: "index_accounts_on_public_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.uuid "public_id", null: false
    t.string "title"
    t.string "jira_id"
    t.text "description"
    t.string "status"
    t.decimal "fee"
    t.decimal "amount"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_tasks_on_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.uuid "public_id", null: false
    t.decimal "amount", null: false
    t.string "kind", null: false
    t.string "reason"
    t.bigint "account_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["task_id"], name: "index_transactions_on_task_id"
  end

  add_foreign_key "tasks", "accounts"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "tasks"
end
