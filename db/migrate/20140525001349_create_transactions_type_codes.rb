class CreateTransactionsTypeCodes < ActiveRecord::Migration
  def change
    create_table :transactions_type_codes, id: false do |t|
    	t.integer :transaction_id, null: false
    	t.integer :type_code_id, null: false
    end
  end
end
