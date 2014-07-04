class AddCallCountToRoutingNumber < ActiveRecord::Migration
  def change
    add_column :routing_numbers, :call_count, :integer
  end
end
