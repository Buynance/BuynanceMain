class AddFundingTypeToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :funding_type, :integer, default: 0
  end
end
