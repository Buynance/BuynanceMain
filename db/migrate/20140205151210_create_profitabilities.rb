class CreateProfitabilities < ActiveRecord::Migration
  def change
    create_table :profitabilities do |t|
      t.float :daily_cash_collection_amount
      t.float :gross_profit_margin
      t.float :projected_daily_profit

      t.timestamps
    end
  end
end
