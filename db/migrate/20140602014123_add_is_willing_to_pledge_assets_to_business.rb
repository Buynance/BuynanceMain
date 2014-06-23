class AddIsWillingToPledgeAssetsToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :is_willing_to_pledge_assets, :boolean
    add_column :businesses, :value_of_assets, :float
  end
end
