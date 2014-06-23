class AddColumnsToBankAccount < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :average_balance_one_month_ago, :float
    add_column :bank_accounts, :average_balance_two_months_ago, :float
    add_column :bank_accounts, :average_balance_three_months_ago, :float
    add_column :bank_accounts, :average_negative_days, :integer
  end
end
