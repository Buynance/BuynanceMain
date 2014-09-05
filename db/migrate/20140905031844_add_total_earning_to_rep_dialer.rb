class AddTotalEarningToRepDialer < ActiveRecord::Migration
  def change
    add_column :rep_dialers, :total_earning, :float
  end
end
