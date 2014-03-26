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

ActiveRecord::Schema.define(version: 20140326185820) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "anonymous_users", force: true do |t|
    t.integer  "request_count"
    t.string   "ip"
    t.datetime "first_request"
    t.datetime "last_request"
    t.integer  "user_id"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_types", force: true do |t|
    t.string   "name"
    t.boolean  "is_rejecting"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_user_sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "business_user_sessions", ["session_id"], name: "index_business_user_sessions_on_session_id"
  add_index "business_user_sessions", ["updated_at"], name: "index_business_user_sessions_on_updated_at"

  create_table "business_users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "address_line_one"
    t.string   "address_line_two"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "title"
    t.datetime "date_of_birth"
    t.integer  "home_phone_number"
    t.string   "mobile_phone_number"
    t.integer  "ownership_percentage"
    t.string   "email",                                           null: false
    t.string   "crypted_password",                                null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "login_count",                         default: 0, null: false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "open_date"
    t.boolean  "is_accepting"
    t.boolean  "is_authenticated"
    t.boolean  "is_email_confirmed"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "failed_login_count",                  default: 0, null: false
    t.datetime "last_request_at"
    t.boolean  "is_finished_application"
    t.string   "activation_code"
    t.string   "recovery_code"
    t.string   "confirmation_code"
    t.boolean  "is_confirmed"
    t.integer  "business_id"
    t.boolean  "is_finished_registration"
    t.string   "statement_one_month_ago"
    t.string   "statement_two_months_ago"
    t.string   "statement_three_months_ago"
    t.string   "drivers_license"
    t.string   "business_license"
    t.boolean  "is_complete_information_application"
  end

  create_table "businesses", force: true do |t|
    t.string   "crypted_password",                   default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "login_count",                        default: 0,     null: false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.datetime "open_date"
    t.boolean  "is_accepting"
    t.boolean  "is_authenticated"
    t.string   "owner_first_name"
    t.string   "owner_last_name"
    t.boolean  "is_accept_credit_cards"
    t.integer  "earned_one_month_ago"
    t.integer  "earned_two_months_ago"
    t.integer  "earned_three_months_ago"
    t.boolean  "is_passed_step_one"
    t.string   "phone_number"
    t.string   "street_address_one"
    t.string   "street_address_two"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.boolean  "is_paying_back"
    t.integer  "previous_merchant_id"
    t.integer  "total_previous_payback_amount"
    t.integer  "total_previous_payback_balance"
    t.boolean  "is_email_confirmed"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "failed_login_count",                 default: 0,     null: false
    t.datetime "last_request_at"
    t.boolean  "passed_recent_earnings",             default: false
    t.boolean  "passed_personal_information",        default: false
    t.boolean  "passed_merchant_history",            default: false
    t.boolean  "is_finished_application"
    t.string   "activation_code"
    t.string   "most_recent_funder"
    t.integer  "approximate_credit_score"
    t.string   "business_type"
    t.boolean  "is_tax_lien"
    t.integer  "approximate_credit_score_range"
    t.boolean  "is_payment_plan"
    t.boolean  "is_ever_bankruptcy"
    t.integer  "average_daily_balance_bank_account"
    t.integer  "amount_negative_balance_past_month"
    t.integer  "business_type_id"
    t.string   "recovery_code"
    t.string   "confirmation_code"
    t.boolean  "is_confirmed"
    t.integer  "loan_reason_id"
    t.integer  "years_in_business"
    t.boolean  "is_judgement"
    t.integer  "total_monthly_bills"
    t.integer  "main_user_id"
    t.boolean  "is_accept_offer_disclaimer"
    t.boolean  "is_completed_application",           default: false
    t.integer  "main_offer_id"
    t.string   "email",                              default: "",    null: false
    t.string   "mobile_number"
  end

  add_index "businesses", ["reset_password_token"], name: "index_businesses_on_reset_password_token", unique: true

  create_table "cash_advance_companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_validated"
  end

  create_table "delayed_jobs", force: true do |t|
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

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "documents", force: true do |t|
    t.string   "name"
    t.integer  "business_id"
    t.string   "document"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funders", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "paypal_email"
  end

  add_index "funders", ["email"], name: "index_funders_on_email", unique: true
  add_index "funders", ["reset_password_token"], name: "index_funders_on_reset_password_token", unique: true

  create_table "offers", force: true do |t|
    t.float    "cash_advance_amount"
    t.float    "daily_merchant_cash_advance"
    t.datetime "accepted_at"
    t.datetime "offered_at"
    t.integer  "years_to_collect"
    t.integer  "months_to_collect"
    t.integer  "days_to_collect"
    t.integer  "business_id"
    t.integer  "funder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "total_payback_amount"
    t.float    "factor_rate"
    t.boolean  "is_timed"
    t.boolean  "is_active"
  end

  create_table "profitabilities", force: true do |t|
    t.float    "monthly_cash_collection_amount"
    t.float    "gross_profit_margin"
    t.float    "projected_monthly_profit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "total_monthly_bills"
    t.float    "daily_merchant_cash_advance"
    t.integer  "total_month_fully_profitable_again"
  end

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",       default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["perishable_token"], name: "index_users_on_perishable_token"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
