class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.integer :funder_id
      t.string :state

      t.timestamps
    end
  end
end
