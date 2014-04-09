class AddBusinessUserSession < ActiveRecord::Migration
  def change
  	drop_table :business_user_sessions
    create_table :business_user_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :business_user_sessions, :session_id
    add_index :business_user_sessions, :updated_at
  end
end
