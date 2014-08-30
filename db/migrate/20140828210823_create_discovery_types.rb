class CreateDiscoveryTypes < ActiveRecord::Migration
  def change
    create_table :discovery_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
