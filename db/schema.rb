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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110906181620) do

  create_table "apps", :force => true do |t|
    t.string   "name",                        :null => false
    t.string   "url",                         :null => false
    t.text     "description",                 :null => false
    t.integer  "lock_version", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["name"], :name => "index_apps_on_name", :unique => true

  create_table "comments", :force => true do |t|
    t.text     "comment",    :null => false
    t.integer  "user_id"
    t.integer  "hint_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["hint_id"], :name => "index_comments_on_hint_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "feedbacks", :force => true do |t|
    t.boolean  "positive",   :default => false, :null => false
    t.text     "comments"
    t.integer  "hint_id",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["hint_id"], :name => "index_feedbacks_on_hint_id"
  add_index "feedbacks", ["positive"], :name => "index_feedbacks_on_positive"

  create_table "hints", :force => true do |t|
    t.string   "header",                      :null => false
    t.text     "content",                     :null => false
    t.integer  "importance",                  :null => false
    t.integer  "app_id",                      :null => false
    t.integer  "lock_version", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hints", ["app_id"], :name => "index_hints_on_app_id"
  add_index "hints", ["header"], :name => "index_hints_on_header"

  create_table "hints_tags", :id => false, :force => true do |t|
    t.integer "hint_id", :null => false
    t.integer "tag_id",  :null => false
  end

  add_index "hints_tags", ["hint_id", "tag_id"], :name => "index_hints_tags_on_hint_id_and_tag_id", :unique => true

  create_table "images", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "caption",                           :null => false
    t.string   "image_file_name",                   :null => false
    t.string   "image_content_type",                :null => false
    t.integer  "image_file_size",                   :null => false
    t.datetime "image_updated_at",                  :null => false
    t.integer  "lock_version",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["name"], :name => "index_images_on_name", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "app_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["app_id"], :name => "index_tags_on_app_id"
  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "users", :force => true do |t|
    t.string   "name",                             :null => false
    t.string   "lastname",                         :null => false
    t.string   "email",                            :null => false
    t.string   "crypted_password",                 :null => false
    t.string   "password_salt",                    :null => false
    t.string   "persistence_token",                :null => false
    t.integer  "lock_version",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "versions", :force => true do |t|
    t.integer  "item_id",    :null => false
    t.string   "item_type",  :null => false
    t.string   "event",      :null => false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
