class AddStateToRepDialer < ActiveRecord::Migration
  def change
    add_column :rep_dialers, :state, :string
  end
end
