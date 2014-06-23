class CreateTypeCodes < ActiveRecord::Migration
  def change
    create_table :type_codes do |t|
      t.string :type_code
      t.string :summary

      t.timestamps
    end
  end
end
