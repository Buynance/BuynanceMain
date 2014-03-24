class AddRateToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :factor_rate, :float
  end
end
