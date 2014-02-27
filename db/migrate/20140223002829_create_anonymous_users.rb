class CreateAnonymousUsers < ActiveRecord::Migration
  def change
    create_table :anonymous_users do |t|
      t.integer :request_count
      t.string :ip
      t.datetime :first_request
      t.datetime :last_request
      t.integer :user_id
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
