class CreateQuestionnaireCompleteds < ActiveRecord::Migration
  def change
    create_table :questionnaire_completeds do |t|
      t.integer :questionnaire_id
      t.integer :rep_dialer_id

      t.timestamps
    end
  end
end
