class AddStateToBusiness < ActiveRecord::Migration
  def change
    add_column :business_users, :state, :string
    add_column :offers, :state, :string
  end
end
