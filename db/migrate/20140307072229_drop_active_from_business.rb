class DropActiveFromBusiness < ActiveRecord::Migration
  def self.up
  	remove_column :businesses, :active
  end

  def self.down
      add_column :businesses, :active, :boolean, :default => false, :null => false
  end
end
