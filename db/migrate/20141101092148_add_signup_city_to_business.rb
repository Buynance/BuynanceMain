class AddSignupCityToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :signup_city, :string
    add_column :businesses, :signup_state, :string
  end
end
