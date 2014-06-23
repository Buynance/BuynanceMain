class AddAuthlogicFieldsToFunder < ActiveRecord::Migration
  def change
  	add_column :funders, :crypted_password, :string
  	change_column :funders, :crypted_password, :string, null: false
  	add_column :funders, :password_salt, :string  
  	change_column :funders, :password_salt, :string, null: false   
  	add_column :funders, :persistence_token, :string
  	change_column :funders, :persistence_token, :string,  null: false
  	add_column :funders, :single_access_token, :string
  	change_column :funders, :single_access_token, :string, null: false
  	add_column :funders, :perishable_token, :string
  	change_column :funders, :perishable_token, :string,   null: false
  	add_column :funders, :login_count, :integer,        null: false, :default => 0
  	add_column :funders, :failed_login_count, :integer,  null: false, :default => 0 
  	add_column :funders, :last_request_at, :datetime   
  	add_column :funders, :current_login_at, :datetime     
  	add_column :funders, :last_login_at, :datetime             
  	add_column :funders, :current_login_ip, :string   
  	add_column :funders, :last_login_ip, :string      
  end
end
