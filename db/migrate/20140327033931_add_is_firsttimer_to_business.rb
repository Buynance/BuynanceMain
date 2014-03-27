class AddIsFirsttimerToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :is_first_contact, :boolean, default: true
  end
end
