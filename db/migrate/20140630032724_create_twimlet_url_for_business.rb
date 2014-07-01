class CreateTwimletUrlForBusiness < ActiveRecord::Migration
  def change
    create_table :twimlet_url_for_businesses do |t|
      t.string :twimlet_url
    end
  end
end
