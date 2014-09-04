class AddNameToRepDailers < ActiveRecord::Migration
  def change
    add_column :rep_dialers, :name, :string
  end
end
