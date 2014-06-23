class AddCurrentBalanceToBankAccount < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :current_balance, :float
  end
end
