class CreateRoutingNumbers < ActiveRecord::Migration
  def change
    create_table :routing_numbers do |t|
      t.string :phone_number
      t.string :success_url
      t.integer :business_id
      t.date :last_active

      t.timestamps
    end
  end
end
