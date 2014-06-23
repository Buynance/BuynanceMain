class AddOwnerFullNameToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :owner_full_name, :string
  end
end
