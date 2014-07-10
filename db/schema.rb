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

ActiveRecord::Schema.define(version: 20140710021226) do

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
    t.string   "email"
    t.string   "business_name"
  end

  create_table "bank_accounts", force: true do |t|
    t.integer  "business_id"
    t.integer  "reliability"
    t.string   "account_number"
    t.string   "routing_number"
    t.string   "logo_url"
    t.string   "bank_url"
    t.string   "institution_name"
    t.integer  "institution_number"
    t.datetime "transactions_from_date"
    t.datetime "transactions_to_date"
    t.float    "average_balance"
    t.float    "average_recent_balance"
    t.datetime "as_of_date"
    t.integer  "total_credit_transactions"
    t.integer  "total_debit_transactions"
    t.float    "available_balance"
    t.boolean  "is_transactions_available"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "all_request"
    t.string   "state"
    t.datetime "last_reset"
    t.float    "current_balance"
    t.float    "deposits_one_month_ago"
    t.float    "deposits_two_months_ago"
    t.float    "deposits_three_months_ago"
    t.float    "average_balance_one_month_ago"
    t.float    "average_balance_two_months_ago"
    t.float    "average_balance_three_months_ago"
    t.integer  "average_negative_days"
    t.integer  "total_negative_days"
  end

  create_table "business_type_divisions", force: true do |t|
    t.string   "name"
    t.string   "division_code"
    t.string   "string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_types", force: true do |t|
    t.string   "name"
    t.boolean  "is_rejecting"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "division"
    t.string   "sic_code_two"
    t.integer  "business_type_division_id"
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
    t.string   "mobile_number"
    t.string   "email",                                null: false
    t.string   "crypted_password",                     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "login_count",              default: 0, null: false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "is_accepting"
    t.boolean  "is_authenticated"
    t.boolean  "is_email_confirmed"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "failed_login_count",       default: 0, null: false
    t.datetime "last_request_at"
    t.string   "activation_code"
    t.string   "recovery_code"
    t.integer  "business_id"
    t.boolean  "is_finished_registration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "businesses", force: true do |t|
    t.string   "crypted_password",                               default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "login_count",                                    default: 0,     null: false
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
    t.string   "location_state"
    t.string   "zip_code"
    t.boolean  "is_paying_back"
    t.integer  "previous_merchant_id"
    t.integer  "total_previous_payback_amount"
    t.integer  "total_previous_payback_balance"
    t.boolean  "is_email_confirmed"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "failed_login_count",                             default: 0,     null: false
    t.datetime "last_request_at"
    t.boolean  "passed_recent_earnings",                         default: false
    t.boolean  "passed_personal_information",                    default: false
    t.boolean  "passed_merchant_history",                        default: false
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
    t.boolean  "is_completed_application",                       default: false
    t.integer  "main_offer_id"
    t.string   "email",                                          default: "",    null: false
    t.string   "mobile_number"
    t.boolean  "is_first_contact",                               default: true
    t.integer  "status"
    t.integer  "main_business_user_id"
    t.string   "state"
    t.string   "initial_request_code"
    t.string   "owner_full_name"
    t.boolean  "is_willing_to_pledge_assets"
    t.float    "value_of_assets"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_refinance"
    t.integer  "deal_type"
    t.date     "previous_loan_date"
    t.float    "closing_fee"
    t.float    "total_previous_loan_amount"
    t.string   "mobile_opt_code"
    t.string   "foward_number"
    t.text     "twimlet_url",                        limit: 255
    t.string   "qualification_state"
    t.integer  "funding_type",                                   default: 0
    t.boolean  "mobile_disclaimer"
  end

  add_index "businesses", ["reset_password_token"], name: "index_businesses_on_reset_password_token", unique: true

  create_table "cash_advance_companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_validated"
  end

  create_table "comfy_blog_comments", force: true do |t|
    t.integer  "post_id",                      null: false
    t.string   "author",                       null: false
    t.string   "email",                        null: false
    t.text     "content"
    t.boolean  "is_published", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_blog_comments", ["post_id", "created_at"], name: "index_comfy_blog_comments_on_post_id_and_created_at"
  add_index "comfy_blog_comments", ["post_id", "is_published", "created_at"], name: "index_blog_comments_on_post_published_created"

  create_table "comfy_blog_posts", force: true do |t|
    t.integer  "blog_id",                                  null: false
    t.string   "title",                                    null: false
    t.string   "slug",                                     null: false
    t.text     "content"
    t.string   "excerpt",      limit: 1024
    t.string   "author"
    t.integer  "year",         limit: 4,                   null: false
    t.integer  "month",        limit: 2,                   null: false
    t.boolean  "is_published",              default: true, null: false
    t.datetime "published_at",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_blog_posts", ["created_at"], name: "index_comfy_blog_posts_on_created_at"
  add_index "comfy_blog_posts", ["is_published", "created_at"], name: "index_comfy_blog_posts_on_is_published_and_created_at"
  add_index "comfy_blog_posts", ["is_published", "year", "month", "slug"], name: "index_blog_posts_on_published_year_month_slug"

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
    t.string   "crypted_password",                    null: false
    t.string   "password_salt",                       null: false
    t.string   "persistence_token",                   null: false
    t.string   "single_access_token",                 null: false
    t.string   "perishable_token",                    null: false
    t.integer  "login_count",            default: 0,  null: false
    t.integer  "failed_login_count",     default: 0,  null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "image_url"
  end

  add_index "funders", ["email"], name: "index_funders_on_email", unique: true
  add_index "funders", ["reset_password_token"], name: "index_funders_on_reset_password_token", unique: true

  create_table "globals", force: true do |t|
    t.string   "variable"
    t.string   "value"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lead_transactions", force: true do |t|
    t.integer  "lead_id"
    t.integer  "funder_id"
    t.integer  "price_in_cents"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", force: true do |t|
    t.integer  "funder_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "business_id"
    t.boolean  "is_sponsor"
  end

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
    t.boolean  "is_best_offer"
    t.string   "state"
    t.integer  "lead_id"
    t.integer  "accepted_lead_id"
    t.integer  "offer_type"
    t.text     "stipulations"
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
    t.integer  "other_monthly_loan_collection"
  end

  create_table "routing_numbers", force: true do |t|
    t.string   "phone_number"
    t.text     "success_url",  limit: 255
    t.integer  "business_id"
    t.date     "last_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "call_count"
  end

  create_table "settings", force: true do |t|
    t.string   "var",         null: false
    t.text     "value"
    t.integer  "target_id",   null: false
    t.string   "target_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true

  create_table "transaction_summaries", force: true do |t|
    t.string   "type_name"
    t.string   "type_code"
    t.integer  "total_count"
    t.float    "total_amount"
    t.integer  "recent_count"
    t.float    "recent_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bank_account_id"
  end

  create_table "transactions", force: true do |t|
    t.datetime "transaction_date"
    t.float    "amount"
    t.float    "running_balance"
    t.string   "description"
    t.boolean  "is_refresh"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bank_account_id"
    t.string   "type_code"
  end

  create_table "transactions_type_codes", force: true do |t|
    t.integer "transaction_id", null: false
    t.integer "type_code_id",   null: false
  end

  create_table "twimlet_url_for_businesses", force: true do |t|
    t.string "twimlet_url"
  end

  create_table "type_codes", force: true do |t|
    t.string   "type_code"
    t.string   "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
