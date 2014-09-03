class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :answer_text
      t.integer :question_id
      t.integer :rep_dialer_id

      t.timestamps
    end
  end
end
