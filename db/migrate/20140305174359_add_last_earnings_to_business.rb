class AddLastEarningsToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :earned_one_month_ago, :integer
    add_column :businesses, :earned_two_months_ago, :integer
    add_column :businesses, :eanred_three_months_ago, :integer
    add_column :businesses, :is_passed_step_one, :boolean
    add_column :businesses, :phone_number, :string
    add_column :businesses, :street_address_one, :string
    add_column :businesses, :street_address_two, :string
    add_column :businesses, :city, :string
    add_column :businesses, :state, :string
    add_column :businesses, :zip_code, :integer
    add_column :businesses, :is_paying_back, :boolean
    add_column :businesses, :previous_merchant_id, :integer
    add_column :businesses, :total_previous_payback_amount, :integer
    add_column :businesses, :total_previous_payback_balance, :integer
    add_column :businesses, :is_email_confirmed, :boolean
  end
end
