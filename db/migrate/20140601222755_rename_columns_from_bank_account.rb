class RenameColumnsFromBankAccount < ActiveRecord::Migration
  def change
  	rename_column :bank_accounts, :insitution_name, :institution_name
  end
end
