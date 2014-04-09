class AddStateLocationToBusiness < ActiveRecord::Migration
  def change
  	rename_column :businesses, :state, :location_state
    add_column :businesses, :state, :string
  end
end
