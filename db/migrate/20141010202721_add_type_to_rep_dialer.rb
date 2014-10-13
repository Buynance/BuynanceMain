class AddTypeToRepDialer < ActiveRecord::Migration
  def change
    add_column :rep_dialers, :type, :string, :null => false, :default => "Friend"
  end
end
