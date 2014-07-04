class AddQualificationStateToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :qualification_state, :string
  end
end
