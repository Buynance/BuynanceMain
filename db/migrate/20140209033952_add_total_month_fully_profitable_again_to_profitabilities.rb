class AddTotalMonthFullyProfitableAgainToProfitabilities < ActiveRecord::Migration
  def change
    add_column :profitabilities, :total_month_fully_profitable_again, :integer
  end
end
