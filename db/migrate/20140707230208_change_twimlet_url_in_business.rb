class ChangeTwimletUrlInBusiness < ActiveRecord::Migration
  def change
  	change_column :businesses, :twimlet_url, :text
  end
end
