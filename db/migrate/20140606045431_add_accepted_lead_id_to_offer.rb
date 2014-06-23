class AddAcceptedLeadIdToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :accepted_lead_id, :integer
  end
end
