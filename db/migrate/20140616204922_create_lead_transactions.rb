class CreateLeadTransactions < ActiveRecord::Migration
  def change
    create_table :lead_transactions do |t|
      t.integer :lead_id
      t.integer :funder_id
      t.integer :price_in_cents
      t.string :state

      t.timestamps
    end
  end
end
