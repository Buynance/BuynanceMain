class AddMobileOptCodeToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :mobile_opt_code, :string
  end
end
