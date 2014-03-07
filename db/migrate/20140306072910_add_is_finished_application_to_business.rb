class AddIsFinishedApplicationToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :is_finished_application, :boolean
  end
end
