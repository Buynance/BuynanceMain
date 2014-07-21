class CreateTranslatorValues < ActiveRecord::Migration
  def change
    create_table :translator_values do |t|
      t.string :key
      t.string :locale, default: "en"
      t.text :value, default: ""
      t.integer :translator_page_id

      t.timestamps
    end
  end
end
