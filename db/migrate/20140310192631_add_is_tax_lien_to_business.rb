class AddIsTaxLienToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :is_tax_lien, :boolean
  end
end
