class AddFowardNumberToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :foward_number, :string
  end
end
