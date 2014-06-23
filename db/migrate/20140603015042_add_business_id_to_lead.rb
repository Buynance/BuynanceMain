class AddBusinessIdToLead < ActiveRecord::Migration
  def change
    add_column :leads, :business_id, :integer
  end
end
