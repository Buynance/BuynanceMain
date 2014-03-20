class RenameColumnForBusinessTypes < ActiveRecord::Migration
  def change
  	rename_column :business_types, :is_accepted, :is_rejecting
  end
end
