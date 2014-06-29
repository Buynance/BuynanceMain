class ChangeZipCodeInBusiness < ActiveRecord::Migration
  def change
  	change_column :businesses, :zip_code, :string
  end
end
