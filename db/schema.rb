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

ActiveRecord::Schema.define(version: 20171003053654) do

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,     null: false
    t.integer  "application_id",    limit: 4,     null: false
    t.string   "token",             limit: 255,   null: false
    t.integer  "expires_in",        limit: 4,     null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["application_id"], name: "fk_rails_b4b53e07b8", using: :btree
  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id",      limit: 4
    t.integer  "application_id",         limit: 4
    t.string   "token",                  limit: 255,              null: false
    t.string   "refresh_token",          limit: 255
    t.integer  "expires_in",             limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                                      null: false
    t.string   "scopes",                 limit: 255
    t.string   "previous_refresh_token", limit: 255, default: "", null: false
  end

  add_index "oauth_access_tokens", ["application_id"], name: "fk_rails_732cb83ab7", using: :btree
  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,                null: false
    t.string   "uid",          limit: 255,                null: false
    t.string   "secret",       limit: 255,                null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",       limit: 255,   default: "", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

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
    t.string   "reset_token",   limit: 255
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

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
end
