class CreateBusinessTypeDivisions < ActiveRecord::Migration
  def change
    create_table :business_type_divisions do |t|
      t.string :name
      t.string :division_code
      t.string :string

      t.timestamps
    end
  end
end
