class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.integer :business_id
      t.integer :reliability
      t.integer :account_number
      t.integer :routing_number
      t.string :logo_url
      t.string :bank_url
      t.string :insitution_name
      t.integer :institution_number
      t.datetime :transactions_from_date
      t.datetime :transactions_to_date
      t.float :average_balance
      t.float :average_recent_balance
      t.datetime :as_of_date
      t.integer :total_credit_transactions
      t.integer :total_debit_transactions
      t.float :available_balance
      t.boolean :is_transactions_available

      t.timestamps
    end
  end
end
