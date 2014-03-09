class RenameMerchantList < ActiveRecord::Migration
  def self.up
    rename_table :merchant_lists, :cash_advance_companies
  end

 def self.down
    rename_table :cash_advance_companies, :merchant_lists
 end
end
