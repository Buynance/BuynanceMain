class AddPastFunderToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :most_recent_funder, :string
  end
end
