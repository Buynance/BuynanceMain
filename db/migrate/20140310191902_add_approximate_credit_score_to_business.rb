class AddApproximateCreditScoreToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :approximate_credit_score, :integer
  end
end
