class AddRepDialerIdToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :rep_dialer_id, :integer
  end
end
