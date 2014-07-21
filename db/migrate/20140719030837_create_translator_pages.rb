class CreateTranslatorPages < ActiveRecord::Migration
  def change
    create_table :translator_pages do |t|
      t.string :controller
      t.string :page

      t.timestamps
    end
  end
end
