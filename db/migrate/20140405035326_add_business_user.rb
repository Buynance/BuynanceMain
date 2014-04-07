class AddBusinessUser < ActiveRecord::Migration
  def change
  	#drop_table :business_users
    create_table :business_users do |t|
	    t.string   "first_name"
	    t.string   "last_name"
	    t.string   "phone_number"
	    t.string   "mobile_number"
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
	    t.boolean  "is_accepting"
	    t.boolean  "is_authenticated"
	    t.boolean  "is_email_confirmed"
	    t.string   "password_salt"
	    t.string   "persistence_token"
	    t.string   "single_access_token"
	    t.string   "perishable_token"
	    t.integer  "failed_login_count",                  default: 0, null: false
	    t.datetime "last_request_at"
	    t.string   "activation_code"
	    t.string   "recovery_code"
	    t.integer  "business_id"
	    t.boolean  "is_finished_registration"

        t.timestamps
    end
  end
end
