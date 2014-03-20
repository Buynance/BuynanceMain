class RenameIsJudgementBusinesses < ActiveRecord::Migration
  def change
  	rename_column :businesses, :is_judgment, :is_judgement
  end
end
