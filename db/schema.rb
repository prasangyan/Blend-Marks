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

ActiveRecord::Schema.define(:version => 20110629151930) do

  create_table "errors", :force => true do |t|
    t.string   "title"
    t.text     "fulltrace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "link"
    t.text     "description"
    t.integer  "tag_id"
    t.integer  "user_id"
    t.integer  "createdby"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.text     "title"
    t.string   "group_id"
  end

  create_table "notificationlinks", :force => true do |t|
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.boolean  "remember_me"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.boolean  "isnotificationsubscribed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "reset_code"
    t.string   "bookmarkletcode"
    t.integer  "link_id"
    t.string   "group_id"
  end

  # for testing purpose
  create_table "user_session", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.boolean  "remember_me"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.boolean  "isnotificationsubscribed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "reset_code"
    t.string   "bookmarkletcode"
    t.integer  "link_id"
    t.string   "group_id"
  end

  create_table "error", :force => true do |t|
    t.string   "title"
    t.text     "fulltrace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "link", :force => true do |t|
    t.string   "link"
    t.text     "description"
    t.integer  "tag_id"
    t.integer  "user_id"
    t.integer  "createdby"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.text     "title"
    t.string   "group_id"
  end

  create_table "notificationlink", :force => true do |t|
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscription", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contentsearch", :force => true do |t|

  end
  
end
