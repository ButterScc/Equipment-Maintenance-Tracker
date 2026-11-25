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

ActiveRecord::Schema[8.1].define(version: 2026_11_25_081405) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "breakdown_reports", force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.datetime "reported_at"
    t.string "severity"
    t.text "description"
    t.string "status"
    t.text "resolution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_breakdown_reports_on_equipment_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "category"
    t.string "location"
    t.string "status"
    t.string "manufacturer"
    t.string "model"
    t.string "serial_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "priority"
    t.date "next_maintenance_date"
    t.integer "maintenance_interval_days"
    t.boolean "next_maintenance_manual", default: false
  end

  create_table "equipment_status_histories", force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.string "previous_status"
    t.string "new_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_equipment_status_histories_on_equipment_id"
  end

  create_table "maintenance_records", force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.date "maintenance_date"
    t.string "maintenance_type"
    t.text "description"
    t.string "technician"
    t.decimal "cost"
    t.date "next_due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_maintenance_records_on_equipment_id"
  end

  create_table "maintenance_schedules", force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.string "title"
    t.string "maintenance_type"
    t.date "scheduled_date"
    t.string "status"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_maintenance_schedules_on_equipment_id"
  end

  create_table "maintenances", force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.date "maintenance_date"
    t.string "maintenance_type"
    t.string "technician"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "next_maintenance_date"
    t.index ["equipment_id"], name: "index_maintenances_on_equipment_id"
  end

  add_foreign_key "breakdown_reports", "equipment"
  add_foreign_key "equipment_status_histories", "equipment"
  add_foreign_key "maintenance_records", "equipment"
  add_foreign_key "maintenance_schedules", "equipment"
  add_foreign_key "maintenances", "equipment"
end
