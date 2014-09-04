class ChangeRefCodeName < ActiveRecord::Migration
  def change
  	rename_column :rep_dialers, :ref_code, :referral_code
  end
end
