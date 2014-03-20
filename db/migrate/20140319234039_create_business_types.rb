class CreateBusinessTypes < ActiveRecord::Migration
  def change
    create_table :business_types do |t|
      t.string :name
      t.boolean :is_accepted

      t.timestamps
    end
  end
end
