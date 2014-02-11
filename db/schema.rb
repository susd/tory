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

ActiveRecord::Schema.define(version: 20140211000219) do
  
  create_table "devices", force: true do |t|
    t.integer  "site_id"
    t.integer  "image_id"
    t.string   "htmlfile"
    t.string   "xmlfile"
    t.string   "cpu"
    t.string   "ram"
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
  end
  
  add_index "devices", ["site_id"], name: "index_devices_on_site_id"
  add_index "devices", ["image_id"], name: "index_devices_on_image_id"

  create_table "images", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

end
