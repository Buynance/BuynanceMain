class CreateGlobals < ActiveRecord::Migration
  def change
    create_table :globals do |t|
      t.string :variable
      t.string :value
      t.string :type

      t.timestamps
    end
  end
end
