class ChangePreviousLoanDateToDate < ActiveRecord::Migration
  def change
  	change_column :businesses, :previous_loan_date, :date
  end
end
