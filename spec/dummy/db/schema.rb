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

ActiveRecord::Schema.define(version: 20141022090034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "modera_banea_dominios", force: true do |t|
    t.string   "dominio",         null: false
    t.string   "updated_usuario", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "modera_banea_dominios", ["dominio"], name: "index_modera_banea_dominios_on_dominio", unique: true, using: :btree

  create_table "usuarios", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
