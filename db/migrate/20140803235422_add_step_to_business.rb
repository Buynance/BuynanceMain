class AddStepToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :step, :string
  end
end
