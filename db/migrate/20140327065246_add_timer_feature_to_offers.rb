class AddTimerFeatureToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :is_best_offer, :boolean
  end
end
