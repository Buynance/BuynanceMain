class AddAllRequestToBankAccount < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :all_request, :text
  end
end
