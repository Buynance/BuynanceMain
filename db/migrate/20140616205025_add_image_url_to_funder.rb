class AddImageUrlToFunder < ActiveRecord::Migration
  def change
    add_column :funders, :image_url, :string
    add_column :leads, :is_sponsor, :boolean

  end
end
