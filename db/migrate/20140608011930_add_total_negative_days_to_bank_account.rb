class AddTotalNegativeDaysToBankAccount < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :total_negative_days, :integer
  end
end
