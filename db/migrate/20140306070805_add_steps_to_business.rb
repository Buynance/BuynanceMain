class AddStepsToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :passed_recent_earnings, :boolean, :default => false
    add_column :businesses, :passed_personal_information, :boolean, :default => false
    add_column :businesses, :passed_merchant_history, :boolean, :default => false
  end
end
