class AddFundingTypeToLead < ActiveRecord::Migration
  def change
    add_column :leads, :funding_type, :string
    add_column :leads, :qualification_type, :string
  end
end
