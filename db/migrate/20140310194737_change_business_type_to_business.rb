class ChangeBusinessTypeToBusiness < ActiveRecord::Migration
  def change
  	rename_column :businesses, :type, :business_type
  end
end
