class AddIsRefinanceToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :is_refinance, :boolean
  end
end
