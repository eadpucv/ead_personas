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

ActiveRecord::Schema.define(version: 20160319045427) do

  create_table "casserver_lt", force: :cascade do |t|
    t.string   "ticket",          limit: 255, null: false
    t.datetime "created_on",                  null: false
    t.datetime "consumed"
    t.string   "client_hostname", limit: 255, null: false
  end

  add_index "casserver_lt", ["ticket"], name: "index_casserver_lt_on_ticket", using: :btree

  create_table "casserver_pgt", force: :cascade do |t|
    t.string   "ticket",            limit: 255, null: false
    t.datetime "created_on",                    null: false
    t.string   "client_hostname",   limit: 255, null: false
    t.string   "iou",               limit: 255, null: false
    t.integer  "service_ticket_id", limit: 4,   null: false
  end

  add_index "casserver_pgt", ["ticket"], name: "index_casserver_pgt_on_ticket", using: :btree

  create_table "casserver_st", force: :cascade do |t|
    t.string   "ticket",            limit: 255,   null: false
    t.text     "service",           limit: 65535, null: false
    t.datetime "created_on",                      null: false
    t.datetime "consumed"
    t.string   "client_hostname",   limit: 255,   null: false
    t.string   "username",          limit: 255,   null: false
    t.string   "type",              limit: 255,   null: false
    t.integer  "granted_by_pgt_id", limit: 4
    t.integer  "granted_by_tgt_id", limit: 4
  end

  add_index "casserver_st", ["ticket"], name: "index_casserver_st_on_ticket", using: :btree

  create_table "casserver_tgt", force: :cascade do |t|
    t.string   "ticket",           limit: 255,   null: false
    t.datetime "created_on",                     null: false
    t.string   "client_hostname",  limit: 255,   null: false
    t.string   "username",         limit: 255,   null: false
    t.text     "extra_attributes", limit: 65535
  end

  add_index "casserver_tgt", ["ticket"], name: "index_casserver_tgt_on_ticket", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "rut",           limit: 20
    t.string   "nombre",        limit: 200
    t.string   "apellido",      limit: 200
    t.string   "mail",          limit: 100,                  null: false
    t.string   "mail_2",        limit: 200
    t.string   "mail_3",        limit: 200
    t.string   "telefono_fijo", limit: 15
    t.string   "telefono_cel",  limit: 15
    t.text     "direccion",     limit: 65535
    t.string   "ciudad",        limit: 200
    t.string   "pais",          limit: 200
    t.string   "tipo",          limit: 2,     default: "n",  null: false
    t.integer  "anoingreso",    limit: 4
    t.string   "carrera",       limit: 100
    t.string   "web",           limit: 200
    t.string   "twitter",       limit: 200
    t.string   "flickr",        limit: 200
    t.string   "usuario",       limit: 50,                   null: false
    t.string   "password",      limit: 200
    t.string   "token",         limit: 20
    t.text     "bio",           limit: 65535
    t.string   "admin",         limit: 2,     default: "no", null: false
    t.datetime "last_edit",                                  null: false
    t.string   "mail_send",     limit: 5
    t.string   "wikipage",      limit: 200
    t.string   "o_user_id",     limit: 200
    t.string   "o_provider",    limit: 200
    t.string   "o_uid",         limit: 200
    t.string   "o_token",       limit: 200
    t.boolean  "status",                      default: true, null: false
  end

  add_index "users", ["mail"], name: "mail", unique: true, using: :btree
  add_index "users", ["usuario"], name: "usuario", unique: true, using: :btree
  add_index "users", ["usuario"], name: "usuario_2", unique: true, using: :btree
  add_index "users", ["usuario"], name: "usuario_3", unique: true, using: :btree

  create_table "usuariosbloqueados", force: :cascade do |t|
    t.string  "rut",           limit: 20
    t.string  "nombre",        limit: 200
    t.string  "apellido",      limit: 200
    t.string  "mail",          limit: 100,                 null: false
    t.string  "mail_2",        limit: 200
    t.string  "mail_3",        limit: 200
    t.string  "telefono_fijo", limit: 15
    t.string  "telefono_cel",  limit: 15
    t.text    "direccion",     limit: 65535
    t.string  "tipo",          limit: 2,     default: "n", null: false
    t.integer "anoingreso",    limit: 4
    t.string  "carrera",       limit: 100
    t.string  "web",           limit: 200
    t.string  "twitter",       limit: 200
    t.string  "flickr",        limit: 200
    t.string  "usuario",       limit: 50,                  null: false
    t.string  "password",      limit: 100
    t.string  "token",         limit: 20,                  null: false
    t.text    "bio",           limit: 65535
  end

  add_index "usuariosbloqueados", ["mail"], name: "mail", unique: true, using: :btree
  add_index "usuariosbloqueados", ["usuario"], name: "usuario", unique: true, using: :btree
  add_index "usuariosbloqueados", ["usuario"], name: "usuario_2", unique: true, using: :btree
  add_index "usuariosbloqueados", ["usuario"], name: "usuario_3", unique: true, using: :btree

end
