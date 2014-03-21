class AddToOffers < ActiveRecord::Migration
  def change
  	add_column :offers, :total_payback_amount, :float
  	remove_column :offers, :is_accepted
  end
end
