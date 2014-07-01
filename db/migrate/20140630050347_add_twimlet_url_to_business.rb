class AddTwimletUrlToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :twimlet_url, :string
  end
end
