class CreateTransactionSummaries < ActiveRecord::Migration
  def change
    create_table :transaction_summaries do |t|
      t.string :type_name
      t.string :type_code
      t.integer :total_count
      t.float :total_amount
      t.integer :recent_count
      t.float :recent_amount

      t.timestamps
    end
  end
end
