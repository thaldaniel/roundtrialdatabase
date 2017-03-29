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

ActiveRecord::Schema.define(version: 20160309135325) do

  create_table "devices", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "devices_proceedings", id: false, force: :cascade do |t|
    t.integer "device_id",     limit: 4
    t.integer "proceeding_id", limit: 4
  end

  add_index "devices_proceedings", ["device_id"], name: "index_devices_proceedings_on_device_id", using: :btree
  add_index "devices_proceedings", ["proceeding_id"], name: "index_devices_proceedings_on_proceeding_id", using: :btree

  create_table "participant_proceeding_results", force: :cascade do |t|
    t.integer  "participant_proceeding_id", limit: 4
    t.text     "results",                   limit: 65535
    t.boolean  "checked"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "sample_name",               limit: 255
    t.boolean  "outlier"
    t.boolean  "deviation"
    t.text     "outliers",                  limit: 65535
    t.text     "diviations",                limit: 65535
  end

  add_index "participant_proceeding_results", ["participant_proceeding_id"], name: "part_pro_res__part_pro_id", using: :btree

  create_table "participant_proceedings", force: :cascade do |t|
    t.integer  "participant_id", limit: 4
    t.integer  "proceeding_id",  limit: 4
    t.integer  "device_id",      limit: 4
    t.text     "metadata",       limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "participant_proceedings", ["device_id"], name: "index_participant_proceedings_on_device_id", using: :btree
  add_index "participant_proceedings", ["participant_id"], name: "index_participant_proceedings_on_participant_id", using: :btree
  add_index "participant_proceedings", ["proceeding_id"], name: "index_participant_proceedings_on_proceeding_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "number",        limit: 4
    t.integer  "roundtrial_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "participants", ["roundtrial_id"], name: "index_participants_on_roundtrial_id", using: :btree

  create_table "proceeding_result_schemas", force: :cascade do |t|
    t.integer  "proceeding_id",   limit: 4
    t.text     "result_schema",   limit: 65535
    t.text     "metadata_schema", limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "proceeding_result_schemas", ["proceeding_id"], name: "index_proceeding_result_schemas_on_proceeding_id", using: :btree

  create_table "proceedings", force: :cascade do |t|
    t.integer  "roundtrial_id", limit: 4
    t.string   "name",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "last_import"
  end

  add_index "proceedings", ["roundtrial_id"], name: "index_proceedings_on_roundtrial_id", using: :btree

  create_table "roundtrials", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "active"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "firstname",  limit: 255
    t.string   "lastname",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
