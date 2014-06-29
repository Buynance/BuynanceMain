class AddBusinessTypeDivisionIdToBusinessType < ActiveRecord::Migration
  def change
    add_column :business_types, :business_type_division, :integer
  end
end
