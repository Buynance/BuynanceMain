class AddRefinanceVariablesToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :deal_type, :integer
    add_column :businesses, :previous_loan_date, :datetime
    add_column :businesses, :closing_fee, :float
    add_column :businesses, :total_previous_loan_amount, :float
  end
end
