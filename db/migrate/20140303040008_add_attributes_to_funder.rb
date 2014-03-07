class AddAttributesToFunder < ActiveRecord::Migration
  def change
    add_column :funders, :name, :string
    add_column :funders, :paypal_email, :string
  end
end
