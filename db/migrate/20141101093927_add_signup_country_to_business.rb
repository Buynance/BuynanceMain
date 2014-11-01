class AddSignupCountryToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :signup_country, :string
    add_column :businesses, :signup_postal, :string
  end
end
