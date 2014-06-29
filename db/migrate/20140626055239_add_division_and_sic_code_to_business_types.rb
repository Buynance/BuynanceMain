class AddDivisionAndSicCodeToBusinessTypes < ActiveRecord::Migration
  def change
    add_column :business_types, :division, :string
    add_column :business_types, :sic_code_two, :string
  end
end
