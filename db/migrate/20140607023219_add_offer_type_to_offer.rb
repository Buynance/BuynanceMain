class AddOfferTypeToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :offer_type, :integer
    add_column :offers, :stipulations, :text
  end
end
