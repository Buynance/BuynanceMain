class RenameFamilyTypeToRole < ActiveRecord::Migration
  def change
  	rename_column :rep_dialers, :type, :role
  end
end
