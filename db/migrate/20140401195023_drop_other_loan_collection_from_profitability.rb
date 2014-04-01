class DropOtherLoanCollectionFromProfitability < ActiveRecord::Migration
  def change
  	remove_column :profitabilities, :other_monthly_loan_collection
  	add_column :profitabilities, :other_monthly_loan_collection, :integer
  end
end
