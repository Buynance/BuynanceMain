class AddRefCodeToRepDialer < ActiveRecord::Migration
  def change
    add_column :rep_dialers, :ref_code, :string
  end
end
