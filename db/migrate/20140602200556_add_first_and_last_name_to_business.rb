class AddFirstAndLastNameToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :first_name, :string
    add_column :businesses, :last_name, :string
  end
end
