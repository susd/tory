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

ActiveRecord::Schema.define(version: 20140529180730) do

  create_table "devices", force: true do |t|
    t.integer  "site_id"
    t.integer  "image_id"
    t.string   "htmlfile"
    t.string   "xmlfile"
    t.string   "cpu"
    t.string   "ram_str"
    t.string   "make"
    t.string   "product"
    t.string   "serial"
    t.string   "uuid"
    t.string   "ip_addr"
    t.string   "mac_address"
    t.integer  "cpu_speed"
    t.text     "banks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.text     "notes"
    t.float    "ram"
  end

  add_index "devices", ["image_id"], name: "index_devices_on_image_id"
  add_index "devices", ["site_id"], name: "index_devices_on_site_id"

  create_table "images", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", force: true do |t|
    t.integer  "site_id"
    t.string   "ip_addr"
    t.integer  "role",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "used_at"
  end

  add_index "servers", ["site_id"], name: "index_servers_on_site_id"

  create_table "sites", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "pxe"
    t.string   "storage"
    t.integer  "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "job"
  end

  add_index "tasks", ["device_id"], name: "index_tasks_on_device_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
