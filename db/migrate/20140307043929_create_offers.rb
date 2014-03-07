class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.float :cash_advance_amount
      t.float :daily_merchant_cash_advance
      t.datetime :accepted_at
      t.datetime :offered_at
      t.boolean :is_accepted
      t.integer :years_to_collect
      t.integer :months_to_collect
      t.integer :days_to_collect
      t.integer :business_id
      t.integer :funder_id

      t.timestamps
    end
  end
end
