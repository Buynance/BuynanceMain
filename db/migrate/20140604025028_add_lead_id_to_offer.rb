class AddLeadIdToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :lead_id, :integer
  end
end
