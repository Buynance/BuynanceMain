class AddMainBusinessUserToBusiness < ActiveRecord::Migration
  def change
  	#remove_column :businesses, :main_business_user_id
    add_column :businesses, :main_business_user_id, :integer
  end
end
