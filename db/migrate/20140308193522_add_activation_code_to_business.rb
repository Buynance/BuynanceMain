class AddActivationCodeToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :activation_code, :string
  end
end
