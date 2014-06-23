class AddLastResetToBankAccount < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :last_reset, :datetime
  end
end
