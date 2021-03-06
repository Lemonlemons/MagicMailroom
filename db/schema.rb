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

ActiveRecord::Schema.define(version: 20161026034637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "company_code"
    t.datetime "deleted_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "users_count",        default: 0
    t.integer  "residents_count",    default: 0
    t.string   "email_subject_line"
    t.string   "email_title"
    t.string   "email_body"
    t.string   "stripe_customer_id"
    t.string   "tier"
    t.datetime "active_until"
    t.string   "subscription_id"
  end

  add_index "companies", ["deleted_at"], name: "index_companies_on_deleted_at", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "deliveries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "resident_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "confirmed",   default: false
  end

  add_index "deliveries", ["deleted_at"], name: "index_deliveries_on_deleted_at", using: :btree
  add_index "deliveries", ["resident_id"], name: "delivery_resident_id_ix", using: :btree
  add_index "deliveries", ["user_id"], name: "delivery_user_id_ix", using: :btree

  create_table "mailkick_opt_outs", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "user_type"
    t.boolean  "active",     default: true, null: false
    t.string   "reason"
    t.string   "list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mailkick_opt_outs", ["email"], name: "index_mailkick_opt_outs_on_email", using: :btree
  add_index "mailkick_opt_outs", ["user_id", "user_type"], name: "index_mailkick_opt_outs_on_user_id_and_user_type", using: :btree

  create_table "residents", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "apartment_number"
    t.integer  "phone"
    t.string   "email"
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "deliveries_count", default: 0
  end

  add_index "residents", ["company_id"], name: "resident_company_id_ix", using: :btree
  add_index "residents", ["deleted_at"], name: "index_residents_on_deleted_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "deleted_at"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "company_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "company_code"
    t.integer  "deliveries_count",       default: 0
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.boolean  "account_admin",          default: false
  end

  add_index "users", ["company_id"], name: "user_company_id_ix", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
