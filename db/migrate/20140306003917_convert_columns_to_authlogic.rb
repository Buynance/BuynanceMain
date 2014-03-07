class ConvertColumnsToAuthlogic < ActiveRecord::Migration
  def change
  	rename_column :businesses, :encrypted_password, :crypted_password
  	rename_column :businesses, :sign_in_count, :login_count
  	rename_column :businesses, :last_sign_in_at, :last_login_at
  	rename_column :businesses, :current_sign_in_at, :current_login_at
  	rename_column :businesses, :current_sign_in_ip, :current_login_ip
  	rename_column :businesses, :last_sign_in_ip, :last_login_ip

  	add_column :businesses, :password_salt, :string
  	add_column :businesses, :persistence_token, :string
  	add_column :businesses, :single_access_token, :string
  	add_column :businesses, :perishable_token, :string
  	add_column :businesses, :failed_login_count, :integer, :null => false, :default => 0
  	add_column :businesses, :last_request_at, :datetime
  end
end