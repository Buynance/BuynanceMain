class AddProfileUrlToRepDialer < ActiveRecord::Migration
  def change
    add_column :rep_dialers, :profile_url, :string
  end
end
