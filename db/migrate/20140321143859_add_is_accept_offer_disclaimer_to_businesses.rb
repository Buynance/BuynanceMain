class AddIsAcceptOfferDisclaimerToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :is_accept_offer_disclaimer, :boolean
  end
end
