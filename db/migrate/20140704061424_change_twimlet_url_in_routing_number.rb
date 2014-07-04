class ChangeTwimletUrlInRoutingNumber < ActiveRecord::Migration
  def change
  	change_column :routing_numbers, :success_url, :text
  end
end
