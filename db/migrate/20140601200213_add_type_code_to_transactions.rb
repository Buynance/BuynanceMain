class AddTypeCodeToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :type_code, :string
  end
end
