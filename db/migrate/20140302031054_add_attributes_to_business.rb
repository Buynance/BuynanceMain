class AddAttributesToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :name, :string
    add_column :businesses, :open_date, :datetime
    add_column :businesses, :is_accepting, :boolean
    add_column :businesses, :is_authenticated, :boolean
    add_column :businesses, :owner_first_name, :string
    add_column :businesses, :owner_last_name, :string
    add_column :businesses, :is_accept_credit_cards, :boolean
  end
end
