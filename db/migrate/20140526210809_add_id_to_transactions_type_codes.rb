class AddIdToTransactionsTypeCodes < ActiveRecord::Migration
  def change
    add_column :transactions_type_codes, :id, :primary_key
  end
end
