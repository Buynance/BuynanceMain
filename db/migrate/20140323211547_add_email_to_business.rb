class AddEmailToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :email, :string,              :null => false, :default => ""
  end
end
