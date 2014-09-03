class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.text :description
      t.string :name

      t.timestamps
    end
  end
end
