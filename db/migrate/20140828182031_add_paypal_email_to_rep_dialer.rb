class AddPaypalEmailToRepDialer < ActiveRecord::Migration
  def change
    add_column :rep_dialers, :paypal_email, :string
  end
end
