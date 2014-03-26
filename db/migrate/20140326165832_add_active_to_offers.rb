class AddActiveToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :is_active, :boolean
  end
end
