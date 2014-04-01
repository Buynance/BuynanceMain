class AddOtherMonthlyLoanCollectionToProfitability < ActiveRecord::Migration
  def change
    add_column :profitabilities, :other_monthly_loan_collection, :string
  end
end
