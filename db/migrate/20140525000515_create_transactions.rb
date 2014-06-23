class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.datetime :transaction_date
      t.float :amount
      t.float :running_balance
      t.string :description
      t.boolean :is_refresh
      t.string :status

      t.timestamps
    end
  end
end
