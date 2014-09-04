class CreateReferralPayments < ActiveRecord::Migration
  def change
    create_table :referral_payments do |t|
      t.integer :business_id
      t.integer :rep_dialer_id
      t.string :state

      t.timestamps
    end
  end
end
