class AddQualifiersToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :loan_reason_id, :integer
    add_column :businesses, :years_in_business, :integer
    add_column :businesses, :is_judgment, :boolean
    add_column :businesses, :total_monthly_bills, :integer
  end
end
