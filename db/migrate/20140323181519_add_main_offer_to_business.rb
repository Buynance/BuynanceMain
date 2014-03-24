class AddMainOfferToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :main_offer_id, :integer
  end
end
