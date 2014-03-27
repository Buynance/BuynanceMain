class AddIsTimedToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :is_timed, :boolean
  end
end
