class AddMobileNumberToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :mobile_number, :string
  end
end
