class Transaction < ActiveRecord::Base
	belongs_to :bank_account

	scope :deposits, -> {where("type_code like ?", "%dp%")}
	scope :overdraft, -> {where("type_code like ?", "%ov%")}
	scope :months_ago, ->(months) {where("transaction_date BETWEEN ? and ?", first.transaction_date.days_ago((months*30) - 1), first.transaction_date.days_ago((months-1)*30))}
	scope :negative_balance, -> {where("running_balance < ?", 0)}
	
	def self.get_transactions_by_type_from_array(transaction_array, type_code_char)
		return_array = Array.new
		transaction_array.each do |transaction|
			transaction.type_codes.each do |type_code|
				if type_code.type_code == type_code_char
					return_array << transaction
				end
			end
		end
		return_array
	end

	private

	def self.transactions_by_type(type_code_char) #Tested
		deposits_array = Array.new
		Transaction.all.each do |transaction|
			transaction.type_codes.each do |type_code|
				if type_code.type_code == type_code_char
					deposits_array << transaction
					break
				end
			end
		end
		return deposits_array
	end
end
