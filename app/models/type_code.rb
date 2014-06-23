class TypeCode < ActiveRecord::Base
	def self.type_codes
		return {payroll: "py", loan_debit: "ld", loan_credit: "lc", overdraft: "ov", ach_debit: "ad", ach_credit: "ac", deposit: "dp"}
	end

end
