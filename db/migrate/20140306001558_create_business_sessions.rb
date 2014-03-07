class CreateBusinessSessions < ActiveRecord::Migration
  def change
    create_table :business_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :business_sessions, :session_id
    add_index :business_sessions, :updated_at
  end
end
