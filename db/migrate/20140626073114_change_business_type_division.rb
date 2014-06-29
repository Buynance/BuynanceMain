class ChangeBusinessTypeDivision < ActiveRecord::Migration
  def change
  	rename_column :business_types, :business_type_division, :business_type_division_id
  end
end
