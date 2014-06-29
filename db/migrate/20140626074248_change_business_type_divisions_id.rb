class ChangeBusinessTypeDivisionsId < ActiveRecord::Migration
  def change
  	rename_column :business_types, :business_type_division_id, :business_type_divisions_id
  end
end
