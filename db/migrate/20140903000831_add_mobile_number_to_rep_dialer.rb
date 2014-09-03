class AddMobileNumberToRepDialer < ActiveRecord::Migration
  def change
    add_column :rep_dialers, :mobile_number, :string
  end
end
