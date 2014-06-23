class AddEmailAndBusinessNameToAnonymousUsers < ActiveRecord::Migration
  def change
    add_column :anonymous_users, :email, :string
    add_column :anonymous_users, :business_name, :string
  end
end
