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

ActiveRecord::Schema.define(version: 20170219015417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "collab_id"
    t.string   "collab_name"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "admins", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "avatar"
    t.string   "name"
    t.string   "token"
    t.string   "uid"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  add_index "admins", ["uid"], name: "index_admins_on_uid", unique: true, using: :btree

  create_table "branches", force: :cascade do |t|
    t.integer  "collab_id"
    t.integer  "creator_id"
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "purpose"
    t.integer  "order"
    t.string   "path"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["type"], name: "index_ckeditor_assets_on_type", using: :btree

  create_table "collab_projects", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "creator_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "private"
  end

  create_table "collaborators", force: :cascade do |t|
    t.integer  "admin_id"
    t.integer  "collab_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comment_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "comment_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_udx", unique: true, using: :btree
  add_index "comment_hierarchies", ["descendant_id"], name: "comment_desc_idx", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "collaborator_id"
    t.text     "body"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "parent_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "collab_id"
    t.string   "name"
    t.string   "email"
    t.string   "invite_token"
    t.string   "message"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "leafs", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "branch_id"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "order"
    t.integer  "leafable_id"
    t.string   "leafable_type"
    t.string   "title"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "source_texts", force: :cascade do |t|
    t.string   "text"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "source_youtubes", force: :cascade do |t|
    t.string   "link"
    t.string   "uid"
    t.string   "title"
    t.datetime "published_at"
    t.integer  "likes"
    t.integer  "dislikes"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "text"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "token"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "link"
    t.string   "title"
    t.datetime "published_at"
    t.integer  "likes"
    t.integer  "dislikes"
    t.string   "uid"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "videos", ["uid"], name: "index_videos_on_uid", using: :btree

end
