class AddRequestCodeToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :initial_request_code, :string
  end
end
