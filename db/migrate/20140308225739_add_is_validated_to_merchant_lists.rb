class AddIsValidatedToMerchantLists < ActiveRecord::Migration
  def change
    add_column :merchant_lists, :is_validated, :boolean
  end
end
