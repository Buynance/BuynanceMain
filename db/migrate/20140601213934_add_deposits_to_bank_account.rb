class AddDepositsToBankAccount < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :deposits_one_month_ago, :float
    add_column :bank_accounts, :deposits_two_months_ago, :float
    add_column :bank_accounts, :deposits_three_months_ago, :float
  end
end
