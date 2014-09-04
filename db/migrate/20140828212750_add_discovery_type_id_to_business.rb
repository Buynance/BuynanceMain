class AddDiscoveryTypeIdToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :discovery_type_id, :integer
  end
end
