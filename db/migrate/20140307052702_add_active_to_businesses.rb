class AddActiveToBusinesses < ActiveRecord::Migration
  def self.up
      add_column :businesses, :active, :boolean, :default => false, :null => false
    end

    def self.down
      remove_column :businesses, :active
    end
end
