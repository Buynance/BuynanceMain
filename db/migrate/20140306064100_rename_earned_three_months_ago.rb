class RenameEarnedThreeMonthsAgo < ActiveRecord::Migration
  def change
  	rename_column :businesses, :eanred_three_months_ago, :earned_three_months_ago
  end
end
