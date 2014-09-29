class AddRequestedAmountToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :requested_amount, :integer
    add_column :businesses, :money_by, :datetime
  end
end
