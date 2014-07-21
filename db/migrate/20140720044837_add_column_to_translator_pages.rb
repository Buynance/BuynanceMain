class AddColumnToTranslatorPages < ActiveRecord::Migration
  def change
    add_column :translator_pages, :section, :string
    add_column :translator_pages, :action, :string
  end
end
