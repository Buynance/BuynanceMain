class ChangeFieldsInProfitabilities < ActiveRecord::Migration
  def change
    rename_column :profitabilities, :daily_cash_collection_amount, :monthly_cash_collection_amount
    add_column :profitabilities, :total_monthly_bills, :float
    add_column :profitabilities, :daily_merchant_cash_advance, :float
    rename_column :profitabilities, :projected_daily_profit, :projected_monthly_profit
  end
end
