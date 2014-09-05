class AddAmountToReferralPayment < ActiveRecord::Migration
  def change
    add_column :referral_payments, :amount, :float
  end
end
