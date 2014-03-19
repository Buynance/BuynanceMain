class AddRecoveryItemsToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :business_type_id, :integer
    add_column :businesses, :recovery_code, :string
    add_column :businesses, :confirmation_code, :string
    add_column :businesses, :is_confirmed, :boolean
  end
end
