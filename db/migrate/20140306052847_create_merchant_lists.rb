class CreateMerchantLists < ActiveRecord::Migration
  def change
    create_table :merchant_lists do |t|
      t.string :name

      t.timestamps
    end
  end
end
