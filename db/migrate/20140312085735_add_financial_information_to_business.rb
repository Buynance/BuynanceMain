class AddFinancialInformationToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :approximate_credit_score_range, :integer
    add_column :businesses, :is_payment_plan, :boolean
    add_column :businesses, :is_ever_bankruptcy, :boolean
    add_column :businesses, :average_daily_balance_bank_account, :integer
    add_column :businesses, :amount_negative_balance_past_month, :integer
  end
end
