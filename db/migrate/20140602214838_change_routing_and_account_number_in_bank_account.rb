class ChangeRoutingAndAccountNumberInBankAccount < ActiveRecord::Migration
  def change
  	change_column :bank_accounts, :routing_number, :string
  	change_column :bank_accounts, :account_number, :string
  end


end
