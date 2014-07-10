class AddMobileDisclaimerToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :mobile_disclaimer, :boolean
  end
end
